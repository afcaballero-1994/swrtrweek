import Foundation

func main(){
    let width = 16 * 30
    let height = 9 * 30

    let kamera: Camera = Camera(imageWidth: width, imageHeight: height, samplesPerPixel: 100, maxDepth: 50)

    var world: HittableList = HittableList()

    let materialGround: Lambertian = Lambertian(albedo: Vec3<Float>(x: 0.8, y: 0.8, z: 0))
    let materialCenter: Lambertian = Lambertian(albedo: Vec3<Float>(x: 0.1, y: 0.2, z: 0.5))
    let materialLeft: Dielectric = Dielectric(ir: 1.5)
    let materialRight: Metal = Metal(albedo: Vec3<Float>(x: 0.8, y: 0.6, z: 0.2), fuzziness: 0)

    world.add(object: Sphere(center: Vec3(x: 0, y: -100.5, z: -1), radius: 100, material: materialGround))
    world.add(object: Sphere(center: Vec3(x: 0, y: 0, z: -1), radius: 0.5, material: materialCenter))
    world.add(object: Sphere(center: Vec3(x: -1, y: 0, z: -1), radius: -0.4, material: materialLeft))
    world.add(object: Sphere(center: Vec3(x: 1, y: 0, z: -1), radius: 0.5, material: materialRight))
    
    kamera.render(world: world)

    //generateExamplePixelData(width: width, height: height, filePath: "./output.ppm")
    //generateExampleBinaryData(width: width, height: height, filePath: "./bina.ppm")
}

main()
