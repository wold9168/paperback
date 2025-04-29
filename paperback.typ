/*
A simple typst template for paperback.

MIT LICENSE

Copyright 2025 Shinonome Tera tanuki (wold9168)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#let init(
  userefmark: false,
  font: ("Source Han Serif SC", "Source Han Serif", "Noto Serif CJK SC", "Noto Serif"),
  enfont: "",
  monofont: (
    "BlexMono Nerd Font",
    "IBM Plex Mono",
    "FiraCode Nerd Font",
    "Noto Sans Mono CJK SC",
    "Source Han Mono",
    "Noto Sans Mono",
  ),
  size: 16pt,
  body,
  header: ""
) = {
  // 设置全局样式，页面边距和纸张大小
  set page(
    margin: (top: 4cm, bottom: 2.0cm, left: 2.7cm, right: 2.7cm),
    paper: "a4",
    header: if header != "" [
      #move(dy: 3em)[
        #align(center)[#text(size: 9pt)[#header]]
        #move(dy: -1em)[#line(length: 100%, stroke: 1pt)]
        #move(dy: -16pt - 1em)[#line(length: 100%, stroke: 2pt)]]
    ],
  )
  // 设置字体
  set text(
    font: if enfont == "" { font } else {
      if type(font) == str {
        ((name: enfont, covers: "latin-in-cjk"), font)
      } else {
        font.insert(0, (name: enfont, covers: "latin-in-cjk"))
        font
      }
    },
    size: size,
    region: "CN",
    lang: "zh",
  )
  show raw: it => {
    text(font: monofont, ligatures: false)[#it]
  }
  // 设置篇章结构
  set heading(
    numbering: (..args) => {
      let nums = args.pos()
      let level = nums.len() - 1
      let label = ("章", "节", "条", "款", "项", "目").at(level)
      [第#nums.at(level)#label]
    },
    supplement: "",
  )
  // 标题前缩进
  show heading: it => {
    if it.depth != 1 {
      move(dx: 2em * (it.depth - 2))[#it]
    } else {
      it
    }
  }
  // 设置「章」一级的标题居中
  show heading.where(level: 1): set align(center)
  // 引用使用※符号
  if userefmark == true {
    show ref: it => {
      text(blue)[#sym.refmark]
    }
  }
  // 超链接变蓝
  show link: it => { text(blue)[#it] }
  // 中文风格缩进
  set par(first-line-indent: (amount: 2em, all: true), justify: true)

  body
}
// 封面函数
#let cover(
  title: "",
  subtitle: "",
  author: "",
  docuid: "",
  date: "",
  school_id: "",
  affiliations: "",
  use_today_date: false,
  logoimg_path: "",
) = {
  // 标题部分
  page(numbering: none,header: "")[
    #align(center)[
      #v(3cm)
      #if logoimg_path != "" {
        image(logoimg_path, width: 70%)
      }
    ]
    #place(horizon + center)[
      #text(size: 24pt, weight: "bold")[
        #title
      ]
      #linebreak()
      #text(size: 20pt)[#subtitle]
      #v(3cm)
      #text(size: 15pt)[
        #grid(
          columns: (1fr, 0.1fr, 2fr),
          inset: 1em,
          ..if docuid != "" {
            ([文档ID], [：], [#docuid])
          },
          ..if author != "" {
            if affiliations != "" {
              ([作者], [：], [#affiliations #author])
            } else {
              ([作者], [：], [#author])
            }
          },
          ..if school_id != "" {
            ([学号], [:], [#school_id])
          },
          ..if date == "" {
            if use_today_date == true {
              ([日期], [：], [#datetime.today().display("[year]年[month]月[day]日")])
            }
          } else {
            ([日期], [：], [#date])
          },
        )
      ]
    ]
  ]
}
// 目录函数
#let toc() = {
  set page(numbering: "目录 第1页")
  counter(page).update(1)
  v(3em)
  outline(indent: 1em)
  pagebreak()
}
#let index = toc
// 正文开始函数
#let body_start() = {
  set page(numbering: "第1页")
  counter(page).update(1)
}
#let mainpart = body_start
// 无前缀标题
#let no_numbering_heading(depth: 1, content) = {
  heading(depth: depth, numbering: none, [#content])
}
#let item = no_numbering_heading
#let abstract = no_numbering_heading
#let intro = no_numbering_heading
