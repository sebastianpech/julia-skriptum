macro Aufgabe01(code)
    result = eval(code)
    quote
        tests = [
            $result(2.1,10) == 2.1^10,
            $result(5,8) == 5^8,
            $result(3,1) == 3^1
        ]
        println("""Ergebnis Aufgabe 01: $(count(tests))/$(length(tests))""")
    end
end

macro Aufgabe02(code)
    quote
        _stdin = stdin
        _stdout = stdout
        try
            (in_rd,in_wr) = redirect_stdin()
            (out_rd,out_wr) = redirect_stdout()
            write(in_wr,"10\n")
            write(in_wr,"10\n")
            write(in_wr,"A\n")
            write(in_wr,"Irgendwas\n")
            write(in_wr,"exit\n")
            $code
            redirect_stdin(_stdin)
            redirect_stdout(_stdout)
            close(out_wr)
            result = readlines(out_rd)
            if result == ["Zehn","Zehn","Buchstabe"]
                println("""Ergebnis Aufgabe 02: richtig""")
            else
                println("""Ergebnis Aufgabe 02: falsch""")
            end
        catch e
            redirect_stdin(_stdin)
            # redirect_stdout(_stdout)
            println("Fehler bei Aufgabe 02!")
            rethrow(e)
        end
    end
end

## Aufgabe 01
## Schreibe eine Funktion die eine beliebige Zahl x hoch n nimmt.
@Aufgabe01 function meine_function(x,n::Int)
    power = one(x)
    for i in 1:n
        power *= x
    end
    return power
end

## Aufgabe 02
## Schreibe eine Funktion die Zeilen vom User einliest und bei 10 -> Zehn und bei A -> Buchstabe ausgibt.
## Bei exit soll sich die funktion beenden.

@Aufgabe02 begin
    while true
        inp = readline()
        if inp == "10"
            println("Zehn")
        end
        if inp == "exit"
            break
        end
    end
end

@Aufgabe02 begin
    while true
        inp = readline()
        if inp == "10"
            println("Zehn")
        end
        if inp == "A"
            println("Buchstabe")
        end
        if inp == "exit"
            break
        end
    end
end
