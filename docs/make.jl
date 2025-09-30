using SimpleTensorTrains
using Documenter

DocMeta.setdocmeta!(
    SimpleTensorTrains,
    :DocTestSetup,
    :(using SimpleTensorTrains);
    recursive = true,
)

makedocs(;
    modules = [SimpleTensorTrains],
    authors = "H. Shinaoka <h.shinaoka@gmail.com>",
    sitename = "SimpleTensorTrains.jl",
    format = Documenter.HTML(;
        canonical = "https://github.com/tensor4all/SimpleTensorTrains.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
    checkdocs = :exports,
)

deploydocs(; repo = "github.com/tensor4all/SimpleTensorTrains.jl.git", devbranch = "main")
