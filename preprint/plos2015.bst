% This ``plos2015.bst'' file is intended for use in PLOS submissions to correctly compile the bibliography according to the PLOS manuscript guidelines updated January 2015.
%
% This is derived from the ``vancouver.bst'' bibliographic style file (for LaTeX/BibTeX), generated with the docstrip utility and modified manually to meet the ``Uniform Requirements for Manuscripts Submitted to Biomedical Journals'' as published in N Engl J Med 1997; 336: 309-315 (also known as the Vancouver style). This specification may be found on the web page of the International Committe of Medical Journal Editors: http://www.icmje.org
%
% Copyright 2004 Folkert van der Beek
%
% This work may be distributed and/or modified under the conditions of the LaTeX Project Public License, either version 1.3 of this license or (at your option) any later version.

ENTRY
  { address
    assignee
    author
    booktitle
    chapter
    cartographer
    day
    edition
    editor
    howpublished
    institution
    inventor
    journal
    key
    month
    note
    number
    organization
    pages
    part
    publisher
    school
    series
    title
    type
    volume
    word
    year
    eprint
    doi
    url
    lastchecked
    updated
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }
STRINGS { urlintro doiprefix }
INTEGERS { hrefform addeprints adddoiresolver }

FUNCTION {init.config.constants}
{
  " Available from: " 'urlintro :=
  "doi:" 'doiprefix :=
  #0 'addeprints :=
  #0 'adddoiresolver :=
  #0 'hrefform :=
}

INTEGERS { 
  bracket.state
  outside.brackets
  open.brackets
  within.brackets
  close.brackets
}

FUNCTION {init.state.consts}
{ #0 'outside.brackets :=
  #1 'open.brackets :=
  #2 'within.brackets :=
  #3 'close.brackets :=

  #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t}

FUNCTION {output.nonnull.original}
{ 's :=
  output.state mid.sentence =
    { ". " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.nonnull}
{
  's :=
  bracket.state close.brackets =
    { "]" *
      outside.brackets 'bracket.state :=
    }
    'skip$
  if$
  bracket.state outside.brackets =
    {
      s
      output.nonnull.original
    }
    {
      bracket.state open.brackets =
        { " [" * }
        { ", " * }
      if$ 
      s * 
      close.brackets 'bracket.state :=
    }
  if$
}

FUNCTION {inbrackets}
{ bracket.state close.brackets =
    { within.brackets 'bracket.state := }
    { open.brackets 'bracket.state := }
  if$
}

FUNCTION {format.lastchecked}
{ lastchecked empty$
    { "" }
    { updated empty$
      { inbrackets "cited " lastchecked * }
      { inbrackets "updated " updated * "; cited " * lastchecked * }
    if$
    }
  if$
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {fin.entry}
{ 
  bracket.state close.brackets =
    { "]" * }
    'skip$
  if$
   add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}

FUNCTION {no.blank.or.punct}
{  "" * before.all 'output.state :=
}

FUNCTION {add.semicolon}
{
  ";" *
  no.blank.or.punct
}

FUNCTION {date.block}
{
  "." *
  no.blank.or.punct
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {warning.if.empty}
{ empty$
    { "No "  swap$ * " in " * cite$ * warning$ }
    { pop$ }
  if$
}

FUNCTION {enclose.check}
{ duplicate$ empty$
    { pop$ pop$ pop$
      ""
    }
    { swap$ * * }
  if$
}

FUNCTION {emphasize.check}
{ "\Bem{" swap$
  "}"     swap$
  enclose.check
}

FUNCTION {bracket.check}
{ "[" swap$
  "]" swap$
  enclose.check
}

FUNCTION {parenthesize.check}
{ "(" swap$
  ")" swap$
  enclose.check
}

STRINGS {z}

FUNCTION {remove.dots}
{ 'z :=
  ""
  { z empty$ not }
  { z #1 #1 substring$
    z #2 global.max$ substring$ 'z :=
    duplicate$ "\" =
    { *
      z #1 #1 substring$
      z #2 global.max$ substring$ 'z :=
      *
    }
    { duplicate$ "." =
      'pop$
      { * }
    if$
    }
    if$
  }
  while$
}

INTEGERS {l}
FUNCTION{string.length}
{
  #1 'l :=
  { duplicate$ duplicate$ #1 l substring$ = not }
    { l #1 + 'l := }
  while$
  pop$ l
}

STRINGS {replace find text}
INTEGERS {find_length}
FUNCTION {find.replace}
{ 
  'replace :=
  'find :=
  'text :=
  find string.length 'find_length :=
  ""
    { text empty$ not }
    { text #1 find_length substring$ find =
      {
        replace *
        text #1 find_length + global.max$ substring$ 'text :=
      }
      { text #1 #1 substring$ *
        text #2  global.max$ substring$ 'text :=
      }
    if$
    }
  while$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ skip$ }

FUNCTION {tie.or.space.prefix}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$
}

FUNCTION {capitalize}
{ "u" change.case$ "t" change.case$ }

FUNCTION {space.word}
{ " " swap$ * " " * }

FUNCTION {bbl.and}
{ "and"}

FUNCTION {bbl.etal}
{ "et~al." }

FUNCTION {bbl.editors}
{ "editors" }

FUNCTION {bbl.editor}
{ "editor" }

FUNCTION {bbl.cartographers}
{ "cartographers" }

FUNCTION {bbl.cartographer}
{ "cartographer" }

FUNCTION {bbl.inventors}
{ "inventors" }

FUNCTION {bbl.inventor}
{ "inventor" }

FUNCTION {bbl.assignees}
{ "assignees" }

FUNCTION {bbl.assignee}
{ "assignee" }

FUNCTION {bbl.edby}
{ "edited by" }

FUNCTION {bbl.edition}
{ "ed." }

FUNCTION {bbl.volume}
{ "vol." }

FUNCTION {bbl.of}
{ "of" }

FUNCTION {bbl.number}
{ "no." }

FUNCTION {bbl.nr}
{ "no." }

FUNCTION {bbl.in}
{ "in" }

FUNCTION {bbl.pages}
{ " p." }

FUNCTION {bbl.page}
{ " p." }

FUNCTION {bbl.chapter}
{ "chap." }

FUNCTION {bbl.techrep}
{ "Tech. Rep." }

FUNCTION {bbl.mthesis}
{ "Master's thesis" }

FUNCTION {bbl.phdthesis}
{ "Ph.D. thesis" }

FUNCTION {bbl.first}
{ "1st" }

FUNCTION {bbl.second}
{ "2nd" }

FUNCTION {bbl.third}
{ "3rd" }

FUNCTION {bbl.fourth}
{ "4th" }

FUNCTION {bbl.fifth}
{ "5th" }

FUNCTION {bbl.st}
{ "st" }

FUNCTION {bbl.nd}
{ "nd" }

FUNCTION {bbl.rd}
{ "rd" }

FUNCTION {bbl.th}
{ "th" }

MACRO {jan} {"Jan."}

MACRO {feb} {"Feb."}

MACRO {mar} {"Mar."}

MACRO {apr} {"Apr."}

MACRO {may} {"May"}

MACRO {jun} {"Jun."}

MACRO {jul} {"Jul."}

MACRO {aug} {"Aug."}

MACRO {sep} {"Sep."}

MACRO {oct} {"Oct."}

MACRO {nov} {"Nov."}

MACRO {dec} {"Dec."}

FUNCTION {eng.ord}
{ duplicate$ "1" swap$ *
  #-2 #1 substring$ "1" =
     { bbl.th * }
     { duplicate$ #-1 #1 substring$
       duplicate$ "1" =
         { pop$ bbl.st * }
         { duplicate$ "2" =
             { pop$ bbl.nd * }
             { "3" =
                 { bbl.rd * }
                 { bbl.th * }
               if$
             }
           if$
          }
       if$
     }
   if$
}

FUNCTION {bibinfo.check}
{ swap$
  duplicate$ missing$
    {
      pop$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ pop$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}

FUNCTION {bibinfo.warn}
{ swap$
  duplicate$ missing$
    {
      swap$ "missing " swap$ * " in " * cite$ * warning$ pop$
      ""
    }
    { duplicate$ empty$
        {
          swap$ "empty " swap$ * " in " * cite$ * warning$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}

STRINGS  { bibinfo}
INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  "." ". " find.replace 's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}{ f{}}{ jj}"
      format.name$
      remove.dots
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        {
          nameptr #6
          #1 + =
          numnames #6
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            {
              "," *
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {
                  " " * bbl.etal *
                }
                { " " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}

FUNCTION {format.names.org}
{ 'bibinfo :=
  duplicate$ empty$ 'skip$ {
  's :=
  "" 't :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{ff~}{vv~}{ll}"
      format.name$
      bibinfo bibinfo.check
      't :=
      nameptr #1 >
        {
          namesleft #1 >
            { "; " * t * }
            {
              ";" *
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                {
                  " " * bbl.etal *
                }
                { " " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  } if$
}

FUNCTION {format.names.ed}
{
  format.names
}

FUNCTION {format.authors}
{ 
  author "author" format.names
  %"." " " "author" find.replace format.names
}

FUNCTION {format.organizations}
{ organization "organization" format.names.org
}

FUNCTION {get.bbl.editor}
{ editor num.names$ #1 > 'bbl.editors 'bbl.editor if$ }

FUNCTION {get.bbl.cartographer}
{ cartographer num.names$ #1 > 'bbl.cartographers 'bbl.cartographer if$ }

FUNCTION {get.bbl.inventor}
{ inventor num.names$ #1 > 'bbl.inventors 'bbl.inventor if$ }

FUNCTION {get.bbl.assignee}
{ assignee num.names$ #1 > 'bbl.assignees 'bbl.assignee if$ }

FUNCTION {format.editors}
{ editor "editor" format.names duplicate$ empty$ 'skip$
    {
      "," *
      " " *
      get.bbl.editor
      *
    }
  if$
}

FUNCTION {format.assignees}
{ assignee "assignee" format.names.org duplicate$ empty$ 'skip$
    {
      "," *
      " " *
      get.bbl.assignee
      *
    }
  if$
}

FUNCTION {format.cartographers}
{ cartographer "cartographer" format.names duplicate$ empty$ 'skip$
    {
      "," *
      " " *
      get.bbl.cartographer
      *
    }
  if$
}

FUNCTION {format.inventors}
{ inventor "inventor" format.names duplicate$ empty$ 'skip$
    {
      "," *
      " " *
      get.bbl.inventor
      *
    }
  if$
}

FUNCTION {format.note}
{
 note empty$
    { "" }
    { note #1 #1 substring$
      duplicate$ "{" =
        'skip$
        { output.state mid.sentence =
          { "l" }
          { "u" }
        if$
        change.case$
        }
      if$
      note #2 global.max$ substring$ * "note" bibinfo.check
    }
  if$
}

FUNCTION {format.title}
{ title
%duplicate$ empty$ 'skip$
%  { "t" change.case$ }
%if$
  "title" bibinfo.check
}

FUNCTION {format.type}
{ type empty$
    'skip$
    { inbrackets type }
    %{ add.blank "[" type * "]" * }
  if$
}

FUNCTION {output.bibitem}
{ outside.brackets 'bracket.state :=
   newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{
  't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {word.in}
{ bbl.in capitalize
  ":" *
  " " * }

FUNCTION {format.journal.date}
{
  ""
  duplicate$ empty$
  year  "year"  bibinfo.check duplicate$ empty$
    {
      swap$ 'skip$
      { "there's a month but no year in " cite$ * warning$ }
      if$
      *
    }
    { swap$ 'skip$
        {
          " " * swap$
        }
      if$
      *
      remove.dots
    }
  if$
  duplicate$ empty$
    'skip$
    {
      before.all 'output.state :=
    after.sentence 'output.state :=
    }
  if$
}

FUNCTION {format.date}
{
  no.blank.or.punct
  ";" 
  duplicate$ empty$
  year  "year"  bibinfo.check duplicate$ empty$
    { swap$ 'skip$
        { "there's a month but no year in " cite$ * warning$ }
      if$
      *
    }
    { swap$ 'skip$
        {
          swap$
          " " * swap$
        }
      if$
      *
    }
  if$
}

FUNCTION {format.btitle}
{ title "title" bibinfo.check
  duplicate$ empty$ 'skip$
    {
    }
  if$
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { bbl.volume volume tie.or.space.prefix
      "volume" bibinfo.check * *
      series "series" bibinfo.check
      duplicate$ empty$ 'pop$
        { swap$ bbl.of space.word * swap$
          emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { number "number" bibinfo.check }
        { output.state mid.sentence =
            { bbl.number }
            { bbl.number capitalize }
          if$
          number tie.or.space.prefix "number" bibinfo.check * *
          bbl.in space.word *
          series "series" bibinfo.check *
        }
      if$
    }
      if$
    }
    { "" }
  if$
}

FUNCTION {is.num}
{ chr.to.int$
  duplicate$ "0" chr.to.int$ < not
  swap$ "9" chr.to.int$ > not and
}

FUNCTION {extract.num}
{ duplicate$ 't :=
  "" 's :=
  { t empty$ not }
  { t #1 #1 substring$
    t #2 global.max$ substring$ 't :=
    duplicate$ is.num
      { s swap$ * 's := }
      { pop$ "" 't := }
    if$
  }
  while$
  s empty$
    'skip$
    { pop$ s }
  if$
}

FUNCTION {convert.edition}
{ extract.num "l" change.case$ 's :=
  s "first" = s "1" = or
    { bbl.first 't := }
    { s "second" = s "2" = or
        { bbl.second 't := }
        { s "third" = s "3" = or
            { bbl.third 't := }
            { s "fourth" = s "4" = or
                { bbl.fourth 't := }
                { s "fifth" = s "5" = or
                    { bbl.fifth 't := }
                    { s #1 #1 substring$ is.num
                        { s eng.ord 't := }
                        { edition 't := }
                      if$
                    }
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
  t
}

FUNCTION {format.edition}
{ edition duplicate$ empty$ 'skip$
    {
      convert.edition
      output.state mid.sentence =
        { "l" }
        { "t" }
      if$ change.case$
      "edition" bibinfo.check
      " " * bbl.edition *
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages duplicate$ empty$ 'skip$
    { duplicate$ multi.page.check
        {
          bbl.pages swap$
          n.dashify
        }
        {
          bbl.page swap$
        }
      if$
      tie.or.space.prefix
      "pages" bibinfo.check
      * *
    }
  if$
}

FUNCTION {format.journal.pages}
{ pages duplicate$ empty$ 'pop$
    { swap$ duplicate$ empty$
        { pop$ pop$ format.pages }
        {
          ":" *
          swap$
          n.dashify
          "pages" bibinfo.check
          *
        }
      if$
    }
  if$
}

FUNCTION {format.vol.num}
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      "(" swap$ * ")" *
    }
  if$ *
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  duplicate$ empty$ 'skip$
    {
      "volume" bibinfo.check
    }
  if$
  number "number" bibinfo.check duplicate$ empty$ 'skip$
    {
      swap$ duplicate$ empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
      swap$
      "(" swap$ * ")" *
    }
  if$ *
  format.journal.pages
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { bbl.chapter }
        { type "l" change.case$
          "type" bibinfo.check
        }
          if$
          chapter tie.or.space.prefix
          "chapter" bibinfo.check
          * *
          pages empty$
        'skip$
        { ", " * format.pages * }
          if$
        }
      if$
    }
    FUNCTION {format.booktitle}
    {
      booktitle "booktitle" bibinfo.check
    }
    FUNCTION {format.in.ed.booktitle}
    { format.booktitle duplicate$ empty$ 'skip$
        {
          editor "editor" format.names.ed duplicate$ empty$ 'pop$
        {
          "," *
          " " *
          get.bbl.editor
          ". " *
          * swap$
          * }
          if$
          word.in swap$ *
        }
      if$
    }
    FUNCTION {format.in.ed.title}
    { format.title duplicate$ empty$ 'skip$
        {
          editor "editor" format.names.ed duplicate$ empty$ 'pop$
        {
          "," *
          " " *
          get.bbl.editor
          ". " *
          * swap$
          * }
          if$
          word.in swap$ *
        }
      if$
    }
    FUNCTION {empty.misc.check}
    { author empty$ title empty$ howpublished empty$
      month empty$ year empty$ note empty$
      and and and and and
        { "all relevant fields are empty in " cite$ * warning$ }
        'skip$
      if$
    }
    FUNCTION {format.thesis.type}
    { type duplicate$ empty$
        'pop$
        { swap$ pop$
          "t" change.case$ "type" bibinfo.check
    }
  if$
}

FUNCTION {format.tr.number}
{
    number "number" bibinfo.check
  %type duplicate$ empty$
    %{ pop$ bbl.techrep }
    %'skip$
  %if$
  %"type" bibinfo.check
  %swap$ duplicate$ empty$
    %{ pop$ "t" change.case$ }
    %{ tie.or.space.prefix * * }
  %if$
}

FUNCTION {format.org.or.pub}
{ 't :=
  ""
  address empty$ t empty$ and
    'skip$
    {
      address "address" bibinfo.check *
      t empty$
        'skip$
        { address empty$
            'skip$
            { ": " * }
          if$
          t *
        }
      if$
    }
  if$
}

FUNCTION {format.publisher.address}
{ publisher "publisher" bibinfo.warn format.org.or.pub
}

FUNCTION {format.organization.address}
{ organization "organization" bibinfo.check format.org.or.pub
}

FUNCTION {format.institution.address}
{ institution "institution" bibinfo.check format.org.or.pub
}

FUNCTION {make.href.null}
{
  pop$
}

FUNCTION {make.href.hypertex}
{ 
  "\special {html:<a href=" quote$ *
  swap$ * quote$ * "> }" * swap$ *
  "\special {html:</a>}" *
}

FUNCTION {make.href.hyperref}
{ 
  "\href {" swap$ * "} {" * swap$ * "}" *
}
FUNCTION {make.href}
{ hrefform #2 =
    'make.href.hyperref
    { hrefform #1 =
        'make.href.hypertex
        'make.href.null
      if$
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
      { hrefform #1 =
          {
            urlintro "\url{" url * "}" * url make.href.hypertex * }
          { urlintro "\url{" * url * "}" * }
       if$
     }
  if$
}

%FUNCTION {format.eprint}
%{ eprint empty$
%    { "" }
%    { eprintprefix eprint * eprinturl eprint * make.href }
%  if$
%}

FUNCTION {format.doi}
{ doi empty$
    { "" }
    {
      new.block
      "doi:{" doi * "}" *
    }
  if$
}

FUNCTION {output.url}
{ url empty$
    'skip$ 
      { new.block 
      format.url output
      format.lastchecked output 
      }
  if$
}

%FUNCTION {output.web.refs}
%{
%  new.block
%  output.url
%  addeprints eprint empty$ not and
%    { format.eprint output.nonnull }
%    'skip$
%  if$
%  adddoiresolver doi empty$ not and
%    { format.doi output.nonnull }
%    'skip$
%  if$
%  addeprints
%    { eprint empty$
%        'skip$
%        { format.eprint output.nonnull }
%      if$
%    }
%    'skip$
%  if$
%}

STRINGS {database}
FUNCTION {webpage}
{ output.bibitem
  author empty$
    { editor empty$
        'skip$
        { format.editors output.nonnull }
      if$
    }
    { editor empty$
        { format.authors output.nonnull }
        { "can't use both author and editor fields in " cite$ * warning$ }
      if$
    }
  if$
%  author empty$
%    'skip$
%    { format.authors output.nonnull }
%  if$
  new.block
  format.title "title" output.check
  journal empty$
    {
      format.type "type"
      publisher empty$
        'skip$
        { format.publisher.address output }
      if$
      "database on the Internet" 'database :=
      type database =
        { format.journal.date "year" output.check }
        { format.date "year" output.check }
      if$
      lastchecked empty$
        'skip$
        { format.lastchecked output }
      if$
      new.block
      part empty$
        'skip$
        { part output }
      if$
      pages empty$
        'skip$
        { pages bracket.check output }
      if$
    }
    { journal
      remove.dots
      "journal" bibinfo.check
      "journal" output.check
      format.type "type"
      format.journal.date "year" output.check
      lastchecked empty$
        'skip$
        { format.lastchecked output
      ";" no.blank.or.punct output
    }
      if$
      no.blank.or.punct format.vol.num output
      pages empty$
        'skip$
    { ":" no.blank.or.punct output
      no.blank.or.punct pages bracket.check output
    }
      if$
      new.block
    }
  if$
  format.url "url" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors "author" output.check
%  format.editors "author and editor" output.check
  format.title "title" output.check
  type missing$
    { skip$ }
    { format.type "type" }
    %{ inbrackets type output }
  if$
  new.block
%  format.publisher.address output
  format.date "year" output.check
  new.block
%  format.note output
  new.block
  howpublished new.block.checka
  howpublished "howpublished" bibinfo.check output
  output.url
  fin.entry
  empty.misc.check
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  organization empty$
    'skip$
    { author empty$
        {
          format.organizations "organization" output.check
    }
    {
      "; " *
      no.blank.or.punct
          format.organizations "organization" output.check
    }
      if$
    }
  if$
  new.block
  format.title "title" output.check
  new.block
  journal
  remove.dots
  "journal" bibinfo.check
  "journal" output.check
  format.journal.date "year" output.check
  add.semicolon
  format.vol.num.pages output
  new.block
  format.doi output
  new.block
%  format.note output
%  output.url
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { editor empty$
        { format.organizations "organization" output.check }
        { format.editors "author and editor" output.check }
      if$
    } 
    { format.authors output.nonnull
      "author and editor" editor either.or.check
    }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  new.block
  format.edition output
  new.sentence
  author empty$ not
  editor empty$ not
  and
    { format.editors "author and editor" output.check }
      'skip$
  if$
  format.number.series output
  format.publisher.address output
  format.date "year" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {booklet}
{ misc }

FUNCTION {dictionary}
{ output.bibitem
  format.booktitle "booktitle" output.check
  format.bvolume output
  new.block
  format.edition output
  new.sentence
  format.publisher.address output
  format.date "year" output.check
  format.btitle "title" output.check
  add.semicolon
%  add.blank
  format.pages "pages" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  format.authors "author" output.check
  new.block
  chapter "chapter" output.check
  new.block
  format.in.ed.title "title" output.check
  format.bvolume output
  format.edition output
  new.sentence
  format.number.series output
  format.publisher.address output
  format.date "year" output.check
  date.block
%  add.blank
  format.pages "pages" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.in.ed.booktitle "booktitle" output.check
  format.bvolume output
  format.edition output
  new.sentence
  format.number.series output
  format.publisher.address output
  format.date "year" output.check
  date.block
%  add.blank
  format.pages "pages" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.in.ed.booktitle "booktitle" output.check
  format.bvolume output
  new.sentence
  format.number.series output
  publisher empty$
    { format.organization.address output }
    { organization "organization" bibinfo.check output
      format.publisher.address output
    }
  if$
  format.date "year" output.check
  date.block
%  add.blank
  format.pages "pages" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {conference}
{inproceedings}

FUNCTION {manual}
{misc}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle
  "title" output.check
  format.type "type" bibinfo.check output
  new.block
  school "school" bibinfo.warn output
  address "address" bibinfo.check output
  format.date "year" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {mastersthesis}
{phdthesis}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization "organization" bibinfo.check output
    }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  editor empty$
    { publisher empty$
        'skip$
        {
          new.sentence
          format.number.series output
          format.publisher.address output
        }
      if$
    }
    { publisher empty$
        {
          new.sentence
          format.organization.address output }
        {
          new.sentence
          organization "organization" bibinfo.check output
          format.publisher.address output
        }
      if$
     }
  if$
      format.date "year" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title
  "title" output.check
  new.block
  format.institution.address output
  format.date "year" output.check
  format.tr.number output.nonnull
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {map}
{ output.bibitem
  format.cartographers "cartographer" output.check
  new.block
  format.title
  "title" output.check
  format.type "type"
  new.block
  format.publisher.address output
  format.date "year" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {patent}
{ output.bibitem
  format.inventors "inventor" output.check
  "; " *
  no.blank.or.punct
  format.assignees "assignee" output.check
  new.block
  format.title
  "title" output.check
  new.block
  format.tr.number output.nonnull
  format.date "year" output.check
  new.block
%  format.note output
  output.url
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  format.date output
  new.block
%  format.note "note" output.check
  output.url
  fin.entry
}

FUNCTION {default.type} { misc }
READ
STRINGS { longest.label }
INTEGERS { number.label longest.label.width }
FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}
FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}
EXECUTE {initialize.longest.label}
ITERATE {longest.label.pass}
FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" *
  write$ newline$
}
EXECUTE {begin.bib}
EXECUTE {init.config.constants}
EXECUTE {init.state.consts}
ITERATE {call.type$}
FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}
EXECUTE {end.bib}
