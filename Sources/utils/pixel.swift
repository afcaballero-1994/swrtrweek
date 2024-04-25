import Foundation

struct Pixel{
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

extension Pixel{
    @inlinable
    static func lerp(a : Pixel, b : Pixel, t : Float) -> Pixel{
        let r: UInt8 = UInt8(Float(a.r) + t * Float((b.r - a.r)))
        let g: UInt8 = UInt8(Float(a.g) + t * Float((b.g - a.g)))
        let b: UInt8 = UInt8(Float(a.b) + t * Float((b.b - a.b)))
        return Pixel(r: r , g: g, b: b)
    }
}

func sdfCircle(center : Vec3<Float>, radius : Float) -> Float{
    return center.magnitude() - radius
}

func sdfBox(center: Vec3<Float>, l: Vec3<Float>) -> Float{
    let d: Vec3<Float> = Vec3.absv(a: center) - l

    return Vec3.maxv(a: d, b: 0).magnitude() + min(max(d.x, d.y), 0.0)
}

func linearToGamma(linearComponent: Float) -> Float{
    if linearComponent > 0{
        return sqrt(linearComponent)
    }

    return 0
}