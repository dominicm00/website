// SPDX-FileCopyrightText: 2023 Dominic Martinez <dom@dominicm.dev>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const katex = require("katex");
const latex_string = process.argv[2];
const html = katex.renderToString(latex_string);
console.log(html);
