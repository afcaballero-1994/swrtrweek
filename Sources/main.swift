import Foundation

func main(){
    let width = 16 * 30
    let height = 9 * 30

    let kamera: Camera = Camera(imageWidth: width, imageHeight: height)

    var world: HittableList = HittableList()
    world.add(object: Sphere(center: Vec3(x: 0, y: 0, z: -1), radius: 0.8))
    world.add(object: Sphere(center: Vec3(x: 0, y: -100.5, z: -1), radius: 100))

    kamera.render(world: world)

    //generateExamplePixelData(width: width, height: height, filePath: "./output.ppm")
    //generateExampleBinaryData(width: width, height: height, filePath: "./bina.ppm")
}

main()
