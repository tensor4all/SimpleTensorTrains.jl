using SimpleTensorNetworks
using Documenter

DocMeta.setdocmeta!(SimpleTensorNetworks, :DocTestSetup, :(using SimpleTensorNetworks); recursive=true)

makedocs(;
    modules=[SimpleTensorNetworks],
    authors="H. Shinaoka <h.shinaoka@gmail.com>",
    sitename="SimpleTensorNetworks.jl",
    format=Documenter.HTML(;
        canonical="https://github.com/tensor4all/SimpleTensorNetworks.jl",
        edit_link="main",
        assets=String[]),
    pages=[
        "Home" => "index.md",
    ]
)

deploydocs(;
    repo="github.com/tensor4all/SimpleTensorNetworks.jl.git",
    devbranch="main",
)
