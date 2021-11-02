#!/bin/bash
# This file is so we can run the engie with a general uci interface
# This idea came from here.
# https://richardanaya.medium.com/tip-make-a-executable-script-from-a-julia-6bd5f9e7aa80
#!/bin/sh
#=
# exec julia -O3 "$0" -- $@
# =#
# include("talk.jl")
# talk()
cd engines/
julia talk.jl