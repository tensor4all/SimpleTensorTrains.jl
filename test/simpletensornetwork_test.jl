@testitem "simpletensornetwork.jl" begin
    import SimpleTensorNetworks:
        Index, dim, IndexedArray, indices, permute, SimpleTensorNetwork
    import Graphs: is_connected, has_edge

    @testset "Construction from IndexedArray objects" begin
        a = Index(2, "A")
        b = Index(2, "B")
        c = Index(2, "C")
        d = Index(2, "D")

        t1 = IndexedArray(rand(2, 2), [a, b])
        t2 = IndexedArray(rand(2, 2), [b, c])
        t3 = IndexedArray(rand(2, 2), [c, d])


        tn = SimpleTensorNetwork([t1, t2, t3])

        @test has_edge(tn, 1 => 2)
        @test has_edge(tn, 2 => 1)
        @test has_edge(tn, 2 => 3)
        @test has_edge(tn, 3 => 2)
        @test is_connected(tn)
    end

    @testset "compute_contraction (without site indices)" begin
        a = Index(2, "A")
        b = Index(2, "B")
        c = Index(2, "C")
        d = Index(2, "D")

        t1 = IndexedArray(rand(2), [a])
        t2 = IndexedArray(rand(2, 2, 2), [a, b, c])
        t3 = IndexedArray(rand(2), [b])
        t4 = IndexedArray(rand(2), [c])

        tn = SimpleTensorNetwork([t1, t2, t3, t4])
        @test only(SimpleTensorNetworks.complete_contraction(tn; root_vertex = 1)) ≈
              only(t1 * t2 * t3 * t4)
    end
end
