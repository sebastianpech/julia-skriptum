# Activate the project in the current folder
using Pkg:@pkg_str
pkg"activate ."

projectdir() = dirname(Base.active_project())
projectdir(x...) = joinpath(projectdir(), x...)

using Weave
using Highlights
using Mustache
using Glob

# Add additional markdown escape character
Weave.WeaveMarkdown.Markdown._latexescape_chars['"'] = "\"{}"


files = projectdir.(["01-Intro.jmd",
         "02-Installation.jmd",
         "03-Interaktion.jmd",
         "05-Kommentare.jmd",
         "06-Variablen.jmd",
         "07-Datentypen.jmd",
         "08-Funktionen.jmd",
         "09-Arrays.jmd",
         "10-Fehlermeldungen.jmd",
         "11-LineareAlgebra.jmd",
         "12-Controlflow.jmd",
         "14-Debugging.jmd",
         "15-SpezielleDatentypen.jmd",
         "16-FileIO.jmd",
         "17-Plotting.jmd",
         "18-Statistik.jmd"])

# Check if a set of special files should be compiled
if length(ARGS) != 0
    files = ARGS
    # Throw error if a file is unknown
    for f in files
        isfile(f) || @error "File '$f' not found."
    end
    if !all(isfile.(files))
        exit(0)
    end
end

##### Stage 1
# Weave all jmd files to tex files
for f in files
    @info "Weaving file $f"
    weave(f,
          out_path=projectdir("build"), # Output into build directory
          doctype = "md2tex",
          template = projectdir("part.tpl"),keep_unicode=true)
end

#### Stage 2
# Replace escaped commands that should actually be forwarded and special unicode characters.

cmd_single_arg(cmd) = Regex("{\\\\textbackslash}(?<cmd>$cmd)\\\\{(?<attrib>.*?)\\\\}") => s"\\\g<cmd>{\g<attrib>}"
r"\\(?<type>begin|end){(?<env>.*?)}",raw"\end{myenv}"
rename_env(cmd,newname) = r"\\(?<type>begin|end){(?<env>.*?)}" => SubstitutionString("\\\\\\g<type>{$newname}")
string_replace(uni,rep) = uni=>rep

forward_this = [
    cmd_single_arg("enquote"),
    cmd_single_arg("footnote"),
    cmd_single_arg("LaTeX"),
    # For dataframe rendering
    string_replace("│","|"),
    string_replace("─","-"),
    string_replace("├","|"),
    string_replace("┼","+"),
    string_replace("┤","|"),
    string_replace("┌","-"),
    string_replace("┬","-"),
    string_replace("┐","-"),
    string_replace("└","-"),
    string_replace("┘","-"),
    string_replace("┴","-"),
]

@info "Replacing commands for forwarding"

for f_jmd in files
    global forward_this
    f_tex = splitext(basename(f_jmd))[1]*".tex"
    lines = readlines(projectdir("build",f_tex))
    open(projectdir("build",f_tex),"w") do out
        println.(Ref(out),map(lines) do l
            reduce(forward_this,init=l) do str,rep
                replace(str,rep)
            end
        end)
    end
end

#### Stage 3
# Compile Main document

commitid() = read(`git rev-parse --verify master --short`,String)[1:end-1]

@info "Creating main tex-Document"
cd(projectdir("build"))
tmppath = tempname()
io = open(tmppath,"w")
latex_template = Mustache.template_from_file(projectdir("julia-skriptum.tpl"))
print(io,render(latex_template,
                juliaversion="\\newcommand{\\juliaversion}{$VERSION}",
                commitid="\\newcommand{\\commitid}{$(commitid())}",
                files=join(["\\input{$(splitext(basename(f))[1]).tex}" for f in files],"\n"),
                stylesheet=Weave.get_highlight_stylesheet(MIME("text/latex"),Highlights.Themes.DefaultTheme)))
close(io)

latex_cmd = "xelatex"
cmd = `$latex_cmd -shell-escape -interaction=batchmode -halt-on-error $tmppath`

try
    @info "Running latex command"
    for r in ["First", "Second", "Third"]
        @info "$r run"
        out = read(cmd,String)
    end
    mv(basename(tmppath)*".pdf",projectdir("build","julia-skriptum.pdf"),force=true)
catch e
    cmd = `$latex_cmd -shell-escape -interaction=nonstopmode build/julia-skriptum.tex`
    @warn "Error converting document to pdf. Try running latex manually" cmd
finally
    @info "Cleaning temporary files"
    tex_path = projectdir("build","julia-skriptum.tex")
    foreach(x->(@warn x),filter(x->occursin("warning",lowercase(x)),readlines(basename(tmppath)*".log")))
    mv(tmppath,tex_path,force=true)
    rm.(readdir(Glob.GlobMatch("$(basename(tmppath)).*")))
end

