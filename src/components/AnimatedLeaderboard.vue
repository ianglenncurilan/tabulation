<template>
  <div class="animated-leaderboard">
    <div class="leaderboard-header">
      <h3 class="text-xl font-bold" style="color: var(--color-light)">
        Live Leaderboard
      </h3>
      <p class="text-sm mt-1" style="color: var(--color-secondary)">
        Real-time team rankings
      </p>
    </div>

    <!-- Table Header -->
    <div class="table-container">
      <div class="table-header">
        <div class="header-cell rank-header">RANK</div>
        <div class="header-cell division-header">TEAM NAME</div>
        <div class="header-cell medal-header">
          <img src="/gold.png" alt="Gold" class="medal-icon gold" />
        </div>
        <div class="header-cell medal-header">
          <img src="/silv.png" alt="Silver" class="medal-icon silver" />
        </div>
        <div class="header-cell medal-header">
          <img src="/brnz.png" alt="Bronze" class="medal-icon bronze" />
        </div>
        <div class="header-cell total-header">TOTAL POINTS</div>
      </div>

      <!-- Table Body -->
      <TransitionGroup name="flip-list" tag="div" class="table-body">
        <div
          v-for="(team, index) in store.sortedTeams"
          :key="team.id"
          class="table-row"
          :class="{ 'top-three': index < 3 }"
        >
          <div class="table-cell rank-cell">
            <div
              class="rank-number"
              :class="{
                'rank-peach': index === 0,
                'rank-blue': index === 1,
                'rank-red': index === 2,
                'rank-normal': index > 2,
              }"
            >
              #{{ index + 1 }}
            </div>
          </div>
          <div class="table-cell division-cell">
            <div class="division-name">{{ team.team_name }}</div>
          </div>
          <div class="table-cell medal-cell">
            <span class="medal-count peach">{{ team.gold_medals || 0 }}</span>
          </div>
          <div class="table-cell medal-cell">
            <span class="medal-count blue">{{ team.silver_medals || 0 }}</span>
          </div>
          <div class="table-cell medal-cell">
            <span class="medal-count red">{{ team.bronze_medals || 0 }}</span>
          </div>
          <div class="table-cell total-cell">
            <div class="total-points">
              {{ getAnimatedPoints(team.id, team.total_points || 0) }}
            </div>
          </div>
        </div>
      </TransitionGroup>
    </div>

    <!-- Empty State -->
    <div v-if="store.sortedTeams.length === 0" class="empty-state">
      <div class="empty-icon">🏆</div>
      <div class="empty-text">No teams ranked yet</div>
      <div class="empty-subtext">
        Start awarding medals to see the leaderboard
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from "vue";
import { useTournamentStore } from "@/stores/useTournamentStore.js";
import { useAnimatedPoints } from "@/composables/useNumberAnimation.js";

const store = useTournamentStore();

// Create animated points for each team
const teamAnimations = computed(() => {
  const animations = {};
  store.sortedTeams.forEach((team) => {
    animations[team.id] = useAnimatedPoints(
      computed(() => team.total_points || 0),
    );
  });
  return animations;
});

const getAnimatedPoints = (teamId, actualPoints) => {
  return teamAnimations.value[teamId]?.value || actualPoints;
};

const formatPoints = (points) => {
  return points.toLocaleString();
};

const getRankClass = (index) => {
  if (index === 0) return "rank-gold";
  if (index === 1) return "rank-silver";
  if (index === 2) return "rank-bronze";
  return "rank-normal";
};
</script>

<style scoped>
.animated-leaderboard {
  padding: 0.5rem;
}

.leaderboard-header {
  margin-bottom: 1rem;
}

.leaderboard-header h3 {
  font-size: 1.125rem;
  font-weight: bold;
  color: var(--color-light);
  margin-bottom: 0.25rem;
}

.leaderboard-header p {
  font-size: 0.75rem;
  color: var(--color-secondary);
  margin: 0;
}

/* Table Container */
.table-container {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  overflow: hidden;
}

/* Table Header */
.table-header {
  display: grid;
  grid-template-columns: 100px 2fr 80px 80px 80px 120px;
  background: rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.header-cell {
  padding: 1rem 0.75rem;
  font-weight: 600;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-secondary);
  display: flex;
  align-items: center;
  justify-content: center;
}

.rank-header {
  justify-content: flex-start;
}

.division-header {
  justify-content: flex-start;
}

.medal-header {
  justify-content: center;
}

.total-header {
  justify-content: flex-end;
}

.medal-icon {
  width: 40px;
  height: 40px;
  object-fit: contain;
}

/* Table Body */
.table-body {
  display: flex;
  flex-direction: column;
}

.table-row {
  display: grid;
  grid-template-columns: 100px 2fr 80px 80px 80px 120px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.02);
}

.table-row:hover {
  background: rgba(255, 255, 255, 0.08);
  transform: translateX(2px);
}

.table-row.top-three {
  background: linear-gradient(
    90deg,
    rgba(255, 192, 203, 0.1) 0%,
    rgba(255, 192, 203, 0.05) 100%
  );
  border-left: 3px solid #ff99cc;
}

.table-row.top-three:hover {
  background: linear-gradient(
    90deg,
    rgba(255, 192, 203, 0.15) 0%,
    rgba(255, 192, 203, 0.08) 100%
  );
}

.table-cell {
  padding: 1rem 0.75rem;
  display: flex;
  align-items: center;
  min-height: 60px;
}

.rank-cell {
  justify-content: flex-start;
}

.division-cell {
  justify-content: flex-start;
}

.medal-cell {
  justify-content: center;
}

.total-cell {
  justify-content: flex-end;
}

/* Cell Content */
.rank-number {
  font-size: 1rem;
  font-weight: bold;
}

.rank-peach {
  color: #ff99cc;
  text-shadow: 0 0 8px rgba(255, 153, 204, 0.5);
}

.rank-blue {
  color: #66b3ff;
  text-shadow: 0 0 8px rgba(102, 179, 255, 0.5);
}

.rank-red {
  color: #ff6666;
  text-shadow: 0 0 8px rgba(255, 102, 102, 0.5);
}

.rank-normal {
  color: var(--color-light);
}

.division-name {
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--color-light);
}

.medal-count {
  font-size: 1rem;
  font-weight: 700;
  padding: 0.5rem 0.75rem;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
  min-width: 40px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.medal-count.peach {
  color: #ff99cc;
  background: linear-gradient(
    135deg,
    rgba(255, 192, 203, 0.2) 0%,
    rgba(255, 192, 203, 0.1) 100%
  );
  border-color: rgba(255, 192, 203, 0.6);
  box-shadow: 0 4px 12px rgba(255, 192, 203, 0.3);
  text-shadow: 0 0 8px rgba(255, 192, 203, 0.5);
}

.medal-count.blue {
  color: #66b3ff;
  background: linear-gradient(
    135deg,
    rgba(102, 179, 255, 0.2) 0%,
    rgba(102, 179, 255, 0.1) 100%
  );
  border-color: rgba(102, 179, 255, 0.6);
  box-shadow: 0 4px 12px rgba(102, 179, 255, 0.3);
  text-shadow: 0 0 8px rgba(102, 179, 255, 0.5);
}

.medal-count.red {
  color: #ff6666;
  background: linear-gradient(
    135deg,
    rgba(255, 102, 102, 0.2) 0%,
    rgba(255, 102, 102, 0.1) 100%
  );
  border-color: rgba(255, 102, 102, 0.6);
  box-shadow: 0 4px 12px rgba(255, 102, 102, 0.3);
  text-shadow: 0 0 8px rgba(255, 102, 102, 0.5);
}

.medal-count:hover {
  transform: scale(1.1) translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
}

.medal-count.peach:hover {
  background: linear-gradient(
    135deg,
    rgba(255, 192, 203, 0.3) 0%,
    rgba(255, 192, 203, 0.2) 100%
  );
  border-color: rgba(255, 192, 203, 0.8);
}

.medal-count.blue:hover {
  background: linear-gradient(
    135deg,
    rgba(102, 179, 255, 0.3) 0%,
    rgba(102, 179, 255, 0.2) 100%
  );
  border-color: rgba(102, 179, 255, 0.8);
}

.medal-count.red:hover {
  background: linear-gradient(
    135deg,
    rgba(255, 102, 102, 0.3) 0%,
    rgba(255, 102, 102, 0.2) 100%
  );
  border-color: rgba(255, 102, 102, 0.8);
}

.total-points {
  font-size: 1.1rem;
  font-weight: bold;
  color: #ff99cc;
}

/* Animations */
.flip-list-move {
  transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.flip-list-enter-active,
.flip-list-leave-active {
  transition: all 0.6s ease;
}

.flip-list-enter-from {
  opacity: 0;
  transform: translateX(-30px);
}

.flip-list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

.flip-list-leave-active {
  position: absolute;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 3rem 1rem;
  color: var(--color-secondary);
}

.empty-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-text {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: var(--color-light);
}

.empty-subtext {
  font-size: 0.875rem;
  opacity: 0.8;
}

/* Responsive */
@media (max-width: 768px) {
  .table-header,
  .table-row {
    grid-template-columns: 80px 1.5fr 60px 60px 60px 100px;
  }

  .header-cell,
  .table-cell {
    padding: 0.75rem 0.5rem;
  }

  .division-name {
    font-size: 0.85rem;
  }

  .medal-count {
    font-size: 0.8rem;
    padding: 0.2rem 0.3rem;
    min-width: 25px;
  }

  .total-points {
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .table-header,
  .table-row {
    grid-template-columns: 70px 1.5fr 50px 50px 50px 80px;
  }

  .header-cell,
  .table-cell {
    padding: 0.5rem 0.25rem;
  }

  .header-cell {
    font-size: 0.65rem;
  }
}
</style>
