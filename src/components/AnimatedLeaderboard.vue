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

    <TransitionGroup name="flip-list" tag="div" class="team-container">
      <div
        v-for="(team, index) in store.sortedTeams"
        :key="team.id"
        class="team-card"
        :class="{ 'top-three': index < 3 }"
      >
        <!-- Rank -->
        <div class="rank-section">
          <div class="rank-number" :class="getRankClass(index)">
            #{{ index + 1 }}
          </div>
          <div v-if="index < 3" class="rank-medal">
            <span v-if="index === 0">🥇</span>
            <span v-else-if="index === 1">🥈</span>
            <span v-else-if="index === 2">🥉</span>
          </div>
        </div>

        <!-- Team Info -->
        <div class="team-info">
          <div class="team-avatar">
            <img
              :src="team.logo_url || '/default-avatar.png'"
              :alt="team.team_name"
              class="avatar-image"
            />
          </div>
          <div class="team-details">
            <div class="team-name">{{ team.team_name }}</div>
            <div class="team-id">ID: {{ team.id.slice(0, 8) }}</div>
          </div>
        </div>

        <!-- Points & Medals -->
        <div class="stats-section">
          <div class="medals">
            <span class="medal gold">🥇 {{ team.gold_medals || 0 }}</span>
            <span class="medal silver">🥈 {{ team.silver_medals || 0 }}</span>
            <span class="medal bronze">🥉 {{ team.bronze_medals || 0 }}</span>
          </div>
          <div class="points">
            <div class="points-number">
              {{ getAnimatedPoints(team.id, team.total_points || 0) }}
            </div>
            <div class="points-label">points</div>
          </div>
        </div>
      </div>
    </TransitionGroup>

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
  padding: 1rem;
}

.leaderboard-header {
  margin-bottom: 2rem;
}

/* The Magic: Smoothly move items when they change position */
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

/* Position indicator */
.flip-list-leave-active {
  position: absolute;
}

.team-container {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.team-card {
  display: flex;
  align-items: center;
  padding: 1rem;
  background: var(--color-surface);
  border: 2px solid var(--color-border);
  border-radius: 12px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.team-card:hover {
  border-color: var(--color-primary);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.team-card.top-three {
  background: linear-gradient(
    135deg,
    var(--color-surface) 0%,
    var(--color-primary) 100%
  );
  border-color: var(--color-primary);
}

/* Rank Section */
.rank-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 60px;
}

.rank-number {
  font-size: 1.25rem;
  font-weight: bold;
  margin-bottom: 0.25rem;
}

.rank-gold {
  color: #ffd700;
  text-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
}

.rank-silver {
  color: #c0c0c0;
  text-shadow: 0 0 10px rgba(192, 192, 192, 0.5);
}

.rank-bronze {
  color: #cd7f32;
  text-shadow: 0 0 10px rgba(205, 127, 50, 0.5);
}

.rank-normal {
  color: var(--color-light);
}

.rank-medal {
  font-size: 1.5rem;
}

/* Team Info */
.team-info {
  display: flex;
  align-items: center;
  flex: 1;
  margin-left: 1rem;
}

.team-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  border: 3px solid var(--color-border);
  margin-right: 1rem;
  background: var(--color-primary);
}

.avatar-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.team-details {
  flex: 1;
}

.team-name {
  font-size: 1rem;
  font-weight: 600;
  color: var(--color-light);
  margin-bottom: 0.25rem;
}

.team-id {
  font-size: 0.75rem;
  color: var(--color-secondary);
  font-family: monospace;
}

/* Stats Section */
.stats-section {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  min-width: 120px;
}

.medals {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.medal {
  font-size: 0.875rem;
  font-weight: bold;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.1);
}

.medal.gold {
  color: #ffd700;
}

.medal.silver {
  color: #c0c0c0;
}

.medal.bronze {
  color: #cd7f32;
}

.points {
  text-align: right;
}

.points-number {
  font-size: 1.5rem;
  font-weight: bold;
  color: var(--color-primary);
  line-height: 1;
}

.points-label {
  font-size: 0.75rem;
  color: var(--color-secondary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
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
  .team-card {
    padding: 0.75rem;
  }

  .rank-section {
    min-width: 50px;
  }

  .rank-number {
    font-size: 1rem;
  }

  .team-avatar {
    width: 40px;
    height: 40px;
  }

  .medals {
    flex-direction: column;
    gap: 0.25rem;
  }

  .points-number {
    font-size: 1.25rem;
  }
}
</style>
