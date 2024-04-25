import Foundation

func main(){
    let width = 16 * 80
    let height = 9 * 80

    let kamera: Camera = Camera(imageWidth: width, imageHeight: height, 
                                    samplesPerPixel: 500, maxDepth: 50, vFov: 45,
                                    lookFrom: Vec3<Float>(x: 13, y: 2, z: 3),
                                    lookAt: Vec3<Float>(x: 0, y: 0, z: 0),
                                    defocusAngle: 0.6,
                                    focusDist: 10
                                )

    var world: HittableList = HittableList()

    let materialGround: Lambertian = Lambertian(albedo: Vec3<Float>(x: 0.5, y: 0.5, z: 0.5))
    world.add(object: Sphere(center: Vec3(x: 0, y: -1000, z: 0), radius: 1000, material: materialGround))
    
    for a in -11..<11{
        for b in -11..<11{
            let matChoose = Float.random(in: 0..<1)
            let center: Vec3<Float> = Vec3<Float>(x: Float(a) + 0.9 * Float.random(in: 0..<1), 
                                    y: 0.2, 
                                    z: Float(b) + 0.9 * Float.random(in: 0..<1))
            
            if (center - Vec3<Float>(x: 4, y: 0.2, z: 0)).magnitude() > 0.9{
                var material: Material

                if matChoose < 0.8{
                    let albedo: Vec3<Float> = Vec3<Float>.generateRandomVec3() .* Vec3<Float>.generateRandomVec3()
                    material = Lambertian(albedo: albedo)
                    world.add(object: Sphere(center: center, radius: 0.2, material: material))
                } else if matChoose < 0.95{
                    let albedo: Vec3<Float> = Vec3<Float>.generateRandomVec3()
                    let fuzz: Float = Float.random(in: 0..<0.5)
                    material = Metal(albedo: albedo, fuzziness: fuzz)
                    world.add(object: Sphere(center: center, radius: 0.2, material: material))
                } else{
                    material = Dielectric(ir: 1.5)
                    world.add(object: Sphere(center: center, radius: 0.2, material: material))
                }
            }
        }
    }

    let material1: Dielectric = Dielectric(ir: 1.5)
    world.add(object: Sphere(center: Vec3<Float>(x: 0, y: 1, z: 0), radius: 1, material: material1))

    let material2: Lambertian = Lambertian(albedo: Vec3<Float>(x: 0.4, y: 0.2, z: 0.1))
    world.add(object: Sphere(center: Vec3<Float>(x: -4, y: 1, z: 0), radius: 1, material: material2))

    let material3: Metal = Metal(albedo: Vec3<Float>(x: 0.7, y: 0.6, z: 0.5), fuzziness: 0)
    world.add(object: Sphere(center: Vec3<Float>(x: 4, y: 1, z: 0), radius: 1, material: material3))
    
    kamera.render(world: world)

    //generateExamplePixelData(width: width, height: height, filePath: "./output.ppm")
    //generateExampleBinaryData(width: width, height: height, filePath: "./bina.ppm")
}

main()
