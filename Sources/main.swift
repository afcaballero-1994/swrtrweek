import Foundation

func rayColor(ray: Ray<Float>) -> Vec3<Float>{
    if isSphereHit(center: Vec3<Float>(x: 0, y: 0, z: -1), radius: 0.8, ray: ray){
        return Vec3<Float>(x: 1, y: 0, z: 0)
    }
    let unitDirection: Vec3<Float> = ray.direction.normalize()
    let a: Float = 0.5 * (unitDirection.y + 1.0)

    return (1 - a) * Vec3<Float>(x: 1, y: 1, z: 1) + a * Vec3<Float>(x: 0.5, y: 0.7, z: 1.0)
}

func isSphereHit(center: Vec3<Float>, radius: Float, ray: Ray<Float>) -> Bool{
    let oc: Vec3<Float> = center - ray.origin
    let a: Float = ray.direction * ray.direction
    let b: Float = -2 * ray.direction * oc
    let c: Float = oc * oc - radius * radius
    let discriminant: Float = b*b - 4*a*c
    return discriminant >= 0
}

func main(){
    let width = 16 * 30
    let height = 9 * 30

    let kamera: Camera = Camera()
    // kamera.viewportHeight = 2
    // kamera.viewporthWidth = kamera.viewportHeight * 16 / 9

    var imgData: String = ""
    imgData.reserveCapacity(width * height * 12)

    for j: Int in 0..<height{
        for i: Int in 0..<width{
            let pixelCenter: Vec3<Float> = kamera.getPixel00Loc(width: width, height: height) + (Float(i) * kamera.getPixelDeltaU(width: width)) + (Float(j) * kamera.getPixelDeltaV(height: height))
            let rayDirection: Vec3<Float> = pixelCenter - kamera.center
            let ray: Ray = Ray(origin: kamera.center, direction: rayDirection)
            let color: Vec3<Float> = rayColor(ray: ray)

            imgData.append(contentsOf: "\(UInt8(color.x * 255)) \(UInt8(color.y * 255)) \(UInt8(color.z * 255))\n")
        }
    }

    writeToPPMASCIIMode(width: width, height: height, imgData: imgData, filePath: "./rendered.ppm")

    //generateExamplePixelData(width: width, height: height, filePath: "./output.ppm")
    //generateExampleBinaryData(width: width, height: height, filePath: "./bina.ppm")
}

main()
