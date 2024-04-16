import Foundation

func main(){
    let width = 16 * 60
    let height = 9 * 60

    let a : Vec3<Float> = Vec3(x: 1.0, y: 3.0, z: -5)
    let b : Vec3<Float> = Vec3(x: 4.0, y: -2, z: -1)
    let c : Vec3<Float> = Vec3(x: 0.2, y: 0, z: 0.5)

    print(Vec3.cross(lhs: a, rhs: b))

    print(c.normalize())

    print(a * b)
    print(a == b)


    let _ = writeToFile(width: width, height: height, colorPixel: c)
    let _ = writeToPPM(width: width, height: height, filePath: "String")
}
