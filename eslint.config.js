import js from '@eslint/js';
import html from 'eslint-plugin-html';
import globals from 'globals';

export default [
  js.configs.recommended,
  {
    files: ['**/*.{js,html}'],
    plugins: { html },
    languageOptions: {
      globals: {
        ...globals.browser,
      },
    },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
    },
  },
  {
    ignores: ['node_modules/', 'assets/'],
  },
];
