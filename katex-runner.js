// SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const katex = require("katex");
const latex_string = process.argv[2];

const options = {
  displayMode: true,
  strict: true,
  trust: true,
};

const html = katex.renderToString(latex_string, options);
console.log(html);
