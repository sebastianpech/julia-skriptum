# Activate the project in the current folder
using Pkg:@pkg_str
pkg"activate ."

using Weave
using Highlights
using Mustache
using Glob

files = ["01-Intro.jmd",
         "02-Installation.jmd",
         "03-Interaktion.jmd",
         "04-Hilfe.jmd",
         "05-Kommentare.jmd",
         "06-Variablen.jmd",
         "07-Fehlermeldungen.jmd",
         "08-Datentypen.jmd",
         "09-Arrays.jmd",
         "10-Funktionen.jmd",
         "11-LineareAlgebra.jmd",
         "12-Controlflow.jmd",
         "13-Methoden.jmd",
         "14-Debugging.jmd",
         "15-SpezielleDatentypen.jmd",
         "16-FileIO.jmd",
         "17-Plotting.jmd",
         "18-Ausblick.jmd"]

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

# Weave all jmd files to tex files
for f in files
    @info "Weaving file"
    weave(f,
          out_path="build", # Output into build directory
          doctype = "md2tex",
          template = "part.tpl")
end

@info "Creating main tex-Document"
tmppath = tempname()
io = open(tmppath,"w")
style = Weave.stylesheet(MIME("text/latex"),Highlights.Themes.DefaultTheme)
latex_template = Mustache.template_from_file("julia-skriptum.tpl")
print(io,render(latex_template,
                files=join(["\\input{build/$(splitext(f)[1]).tex}" for f in files],"\n"),
                stylesheet=Weave.stylesheet(MIME("text/latex"),Highlights.Themes.DefaultTheme)))
close(io)

latex_cmd = "xelatex"
cmd = `$latex_cmd -shell-escape -interaction=batchmode -halt-on-error $tmppath -output-directory build`

try
    @info "Running latex command"
    @info "First run"
    out = read(cmd,String)
    @info "Second run"
    out = read(cmd,String)
    mv(basename(tmppath)*".pdf",joinpath("build","julia-skriptum.pdf"),force=true)
catch e
    failed_path = "failed_"*basename(tmppath)*".tex"
    mv(tmppath,failed_path,force=true)
    cmd = `$latex_cmd -shell-escape -interaction=nonstopmode $(failed_path) -output-directory build`
    @warn "Error converting document to pdf. Try running latex manually" cmd
finally
    @info "Cleaning temporary files"
    rm(tmppath)
    rm.(readdir(Glob.GlobMatch("$(basename(tmppath)).*")))
end


