@testitem "indexedarray.jl" begin
    import SimpleTensorNetworks: Index, dim, IndexedArray, indices, permute, SimpleTensorNetwork

    @testset "Construction from IndexedArray objects" begin
        a = Index(2, "A")
        b = Index(2, "B")
        c = Index(2, "C")

        t1 = IndexedArray(rand(2, 2), [a, b])
        t2 = IndexedArray(rand(2, 2), [b, c])

        tn = SimpleTensorNetwork([t1, t2])
    end

end
