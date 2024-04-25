import Foundation

struct HitRecord{
    var p: Vec3<Float>
    var normal: Vec3<Float>
    var material: Material
    var t: Float
    var frontFace: Bool

    mutating func setFaceNormal(ray: Ray<Float>, outwardNormal: Vec3<Float>){
        frontFace = (ray.direction * outwardNormal) < 0
        if(frontFace){
            normal = outwardNormal
        } else{
            normal = -outwardNormal
        }
    }
}

protocol Hittable{
    func isHit(ray: Ray<Float>, rayT: Interval<Float>, rec: inout HitRecord) -> Bool
}

struct Sphere: Hittable{
    let center: Vec3<Float>
    let radius: Float
    let material: Material

    func isHit(ray: Ray<Float>, rayT: Interval<Float>, rec: inout HitRecord) -> Bool {
        let oc: Vec3<Float> = center - ray.origin
        let a: Float = ray.direction * ray.direction
        let h: Float = ray.direction * oc
        let c: Float = oc * oc - radius * radius

        let discriminant: Float = h*h - a*c
        if discriminant < 0{
            return false
        }

        let sqrtd: Float = sqrtf(discriminant)
        var root: Float = (h - sqrtd) / a
        if !rayT.surround(x: root){
            root = (h + sqrtd) / a
            if !rayT.surround(x: root){
                return false
            }
        }

        rec.t = root
        rec.p = ray.at(t: rec.t)
        let outwardNormal: Vec3<Float> = (rec.p - center) / radius
        rec.setFaceNormal(ray: ray, outwardNormal: outwardNormal)
        rec.material = material

        return true
    }
}

struct HittableList: Hittable{
    var objects: Array<Hittable> = Array<Hittable>()

    mutating func add(object: Hittable){
        objects.append(object)
    }

    mutating func clear(){
        objects.removeAll()
    }


    func isHit(ray: Ray<Float>, rayT: Interval<Float>, rec: inout HitRecord) -> Bool {
        var tmpRecord: HitRecord = HitRecord(p: Vec3(), normal: Vec3(),material: Lambertian(albedo: Vec3()) ,t: 0, frontFace: false)
        var hitSomething: Bool = false
        var closest: Float = rayT.max

        for object in objects{
            if object.isHit(ray: ray, rayT: Interval<Float>(min: rayT.min, max: closest), rec: &tmpRecord){
                hitSomething = true
                closest = tmpRecord.t
                rec = tmpRecord 
            }
        }

        return hitSomething;
    }
}