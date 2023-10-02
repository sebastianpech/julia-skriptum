\documentclass[paper=a4,
fontsize=10pt,
titlepage,
twoside]{scrartcl}

{{{:juliaversion}}}
{{{:commitid}}}

\usepackage{fontspec}
\setmonofont[Path = ../font/,Scale=MatchLowercase,Mapping=tex-text]{DejaVuSansMono}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{float}

\usepackage[left=2.0cm,right=2.0cm,top=1.5cm,bottom=2cm,includehead,marginparwidth=2.5cm,marginparsep=1mm]{geometry}
\usepackage{csquotes}
\usepackage[naustrian]{babel}
\usepackage[
headsepline,
automark
]{scrlayer-scrpage} %Kopf und Fußzeile
\pagestyle{scrheadings}
\clearscrheadfoot
\lohead{\leftmark}
\rohead{\thepage}
\lehead{\thepage}
\rehead{\headmark}

% Title Page
\newcommand{\HRule}{\rule{\linewidth}{0.5mm}} %define a horizontal line
\makeatletter
\renewcommand{\maketitle}{
  \thispagestyle{empty}
	\begin{center}
      \includegraphics[width=0.25\textwidth]{../data/img/Julia_prog_language.png}\\[2cm]
		\HRule \\[0.4cm]
		{ \huge \bfseries \@title}\\
		\HRule \\[0.4cm]
		\textsc{\Large \@subtitle}\\[6.0cm]
		% Author and supervisor
		\begin{minipage}{0.4\textwidth}
			\begin{flushleft} \large
				\emph{Autoren}\\
				\par
				\begingroup
				\leftskip1em
				\rightskip\leftskip
				\@author
				\par
				\endgroup
				\emph{Datum}
				\par
				\begingroup
				\leftskip1em
				\rightskip\leftskip
				\@date
				\par
				\endgroup
				\emph{Erstellt mit Julia}
				\par
				\begingroup
				\leftskip1em
				\rightskip\leftskip
				\juliaversion
				\par
				\endgroup
				\emph{Version}
				\par
				\begingroup
				\leftskip1em
				\rightskip\leftskip
				\commitid
				\par
				\endgroup
			\end{flushleft}
		\end{minipage}
		\hfill
		\begin{minipage}{0.4\textwidth}
			\begin{flushright} \large
				
			\end{flushright}
		\end{minipage}
	\end{center}
	\newpage
}
\makeatother
\usepackage{microtype}
\usepackage{hyperref}
\setlength{\parindent}{0pt}
\setlength{\parskip}{1.2ex}

{{{ :stylesheet }}}

\lstset{
literate={-}{-}1,
frame=l,
framerule=3pt,
rulecolor=\color{black!20},
xleftmargin=7pt
}

\makeatletter
\renewcommand{\verbatim@font}{\ttfamily\footnotesize}
\makeatother

\hypersetup {   pdfauthor = {Sebastian Pech, Raphael Reismüller},
  pdftitle={Programmieren im Bauingenieurwesen},
  colorlinks=TRUE,
  linkcolor=black,
  citecolor=blue,
  urlcolor=blue
}

\makeatletter
\renewcommand*{\fps@figure}{H}
\makeatother

\title{Programmieren im Bauingenieurwesen}
\subtitle{Einführung und Grundlagen}
\author{Sebastian Pech, Raphael Reismüller}
\date{\today}

\begin{document}

\maketitle
\tableofcontents
\cleardoublepage

{{{:files}}}

\end{document}