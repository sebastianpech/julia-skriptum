files = ["01-Intro.jmd",
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
         "18-Statistik.jmd"]

forward_this = [
    r"^# (.*$)"    => s"\\section{\1}",
    r"^## (.*$)"   => s"\\subsection{\1}",
    r"^### (.*$)"  => s"\\subsubsection{\1}",
    r"^#### (.*$)" => s"\\paragraph{\1}",
    r"\[(.*?)\]\((.*?)\)" => s"\\href{\2}{\1}",
    r"<(.*?)>" => s"\\href{\1}{\1}",
]


for f_jmd in files[1:1]
    global forward_this
    f_tex = splitext(f_jmd)[1]*".tex"
    lines = readlines(f_jmd)
    open(f_tex,"w") do out
        println.(Ref(out),map(lines) do l
            reduce(forward_this,init=l) do str,rep
                replace(str,rep)
            end
        end)
    end
end
