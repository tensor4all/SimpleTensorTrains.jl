@testitem begin
    using Aqua
    import SimpleTensorNetworks

    @testset "Aqua" begin
        Aqua.test_stale_deps(SimpleTensorNetworks)
    end
end
