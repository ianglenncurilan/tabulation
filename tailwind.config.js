/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        wreck: {
          dark: '#2C1810',
          red: '#E63946',
          orange: '#F77F00',
          peach: '#FCBF49',
          'light-blue': '#A8DADC',
          blue: '#457B9D',
          'dark-blue': '#1D3557',
        }
      },
      fontFamily: {
        pixel: ['Press Start 2P', 'cursive'],
      },
      boxShadow: {
        'wreck-heavy': '0 0 0 2px #F77F00, 0 0 0 4px #2C1810, 4px 4px 0 4px #2C1810',
        'wreck-card': '0 0 0 2px #F77F00, 0 0 0 4px #2C1810, 3px 3px 0 3px #2C1810',
      }
    },
  },
  plugins: [],
}
