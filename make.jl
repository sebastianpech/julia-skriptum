# Activate the project in the current folder
using Pkg:@pkg_str
pkg"activate ."

using Weave

weave("julia-skriptum.jmd",
      out_path=joinpath(pwd(),"build"), # Output into build directory
      doctype = "md2pdf"
      )
