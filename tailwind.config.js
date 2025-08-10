module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",  // Scan all JS/TS React files for tailwind classes
  ],
  theme: {
    extend: {
      animation: {
        'pulse': 'pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',  // Adds a pulse animation you can use
      }
    },
  },
  plugins: [],
}
