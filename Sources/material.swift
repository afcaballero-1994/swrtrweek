import Foundation

protocol Material{
    func scatter(
        ray: Ray<Float>, rec: HitRecord, colAttenuation: inout Vec3<Float>, scattered: inout Ray<Float>
    ) -> Bool
}

struct Lambertian: Material{
    let albedo: Vec3<Float>

    func scatter(ray: Ray<Float>, rec: HitRecord, colAttenuation: inout Vec3<Float>, scattered: inout Ray<Float>) -> Bool{
        var scatterDirection: Vec3<Float> = rec.normal + Vec3<Float>.randomUnitVector()
        if scatterDirection.nearZero(){
            scatterDirection = rec.normal
        }
        scattered = Ray<Float>(origin: rec.p, direction: scatterDirection) 
        colAttenuation = albedo
        return true
    }
}

struct Metal: Material{
    let albedo: Vec3<Float>
    let fuzziness: Float

    func scatter(ray: Ray<Float>, rec: HitRecord, colAttenuation: inout Vec3<Float>, scattered: inout Ray<Float>) -> Bool{
        let reflected: Vec3<Float> = Vec3<Float>.reflect(v: ray.direction.normalize(), n: rec.normal)
        scattered = Ray<Float>(origin: rec.p, direction: reflected + fuzziness * Vec3<Float>.randomInUnitSphere())
        colAttenuation = albedo;

        return scattered.direction * rec.normal > 0
    }
}

struct Dielectric: Material{
    let ir: Float

    func scatter(ray: Ray<Float>, rec: HitRecord, colAttenuation: inout Vec3<Float>, scattered: inout Ray<Float>) -> Bool{
        colAttenuation = Vec3<Float>(x: 1, y: 1, z: 1)

        let refractionRatio: Float = if rec.frontFace {
            1 / ir
        } else{
            ir
        }

        let unitDirection: Vec3<Float> = ray.direction.normalize()
        let cosTheta: Float = min(-unitDirection * rec.normal, 1)
        let sinTheta: Float = sqrt(1 - cosTheta * cosTheta)
        let cannotRefract: Bool = refractionRatio * sinTheta > 1
        var direction: Vec3<Float> = Vec3()
        if cannotRefract || Dielectric.reflectance(cos: cosTheta, refIdx: refractionRatio) > Float.random(in: 0..<1){
            direction = Vec3.reflect(v: unitDirection, n: rec.normal)
        } else{
            direction = Vec3.refract(uv: unitDirection, n: rec.normal, etaiOverEtat: refractionRatio)
        }

        scattered = Ray<Float>(origin: rec.p, direction: direction)

        return true
    }

    private static func reflectance(cos: Float, refIdx: Float) -> Float{
        var r0: Float = (1 - refIdx) / (1 + refIdx)
        r0 = r0 * r0

        return r0 + (1 - r0 ) * pow(1 - cos, 5)
    }

}