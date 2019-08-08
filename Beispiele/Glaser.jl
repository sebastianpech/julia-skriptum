R(d,λ) = d/λ
sd(d,μ) = μ*d

function p_sat(temp)
    if temp ≥ 0
        return 610.5 * exp((17.269 * temp)/(273.3 + temp))
    else
        return 610.5 * exp((21.875 * temp)/(265.5 + temp))
    end
end

function t_qs(ti::Number,Δts::Vector{<:Number},Δti::Number,Δta::Number)
    ts = zeros(typeof(ti),length(Δts)+2)
    ts[1] = ti
    ts[2] = ts[1]-Δti
    for (i,Δt) in enumerate(Δts)
        ts[i+2] = ts[i+1]-Δt
    end
    ts[end] = ts[end-1]-Δta
    return ts
end

function p_real(p_sats,p_par_i,p_par_a,sds)
    p_real = similar(p_sats)
    p_real[1] = p_par_i
    ds₀ = (p_par_i-p_par_a)/sum(sds)
    for (i,sd) in enumerate(sds)
        p_trial = p_real[i]-sd*ds₀
        p_real[i+1] = p_trial
    end
    return p_real
end

# Innen Klima
ti = 20.0
φi = 0.5
Ri = 0.130

# Außen Klima
ta = -10.0
φa = 0.8
Ra = 0.040

# Schichtaufbau
d = [0.015 , 0.1  , 0.24 , 0.02  , 0.0  , 0.04 , 0.03]
μ = [10.0  , 20.0 , 25.0 , 35.0  , 0.0  , 0.0  , 0.0]
λ = [0.51  , 0.04 , 1.3  ,   1.0 , Inf  , Inf  , Inf]

# Partialdruck innen / außen
p_par_i = φi*p_sat(ti)
p_par_a = φa*p_sat(ta)

Rs  = R.(d,λ)
ΣR = Ri + sum(Rs) + Ra

sds = sd.(d,μ)
Σsd = sum(sds)

Δt = ti-ta
q = Δt/ΣR

# Schichttemperaturen
ts = t_qs(ti,q.*Rs,Ri*q,Ra*q)

# Schichtsättigungsdampfdruck
p_sats = p_sat.(ts[1:end])

# Vorhandener Schichtdampfdruck
p_vorh = p_real(p_sats,p_par_i,p_par_a,sds)
