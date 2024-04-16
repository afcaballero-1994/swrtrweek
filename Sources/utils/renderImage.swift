import Foundation

func writeToPPM(width : Int, height : Int, filePath : String) -> Bool{
    let header : String = "P6\n\(width) \(height)\n255\n"
    
   
    let buffer: UnsafeMutablePointer<Pixel>       = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
    let img:    UnsafeMutableBufferPointer<Pixel> = UnsafeMutableBufferPointer<Pixel>(start: buffer, count: width * height)
    let red: Pixel = Pixel(r: 255, g: 0, b: 0)
    let yelow: Pixel = Pixel(r: 255, g: 255, b: 0)
    
    for j in 0..<height{
        for i in 0..<width{
            // if(i > 100 && i < 250 && j > 25 && j < 250){
            //     img[j * width + i] = Pixel(r: 255, g: 0, b: 0)
            // } else{
            //     img[j * width + i] = Pixel(r: 255, g: 255, b: 0)
            // }
            let colour : Pixel = Pixel.lerp(a: red, b: yelow, t: clamp(start: 0, end: 1, value: Float(j) / Float(height)))
            img[j * width + i] = colour
        }
    }

    let fileManager: FileManager = FileManager()
    
    fileManager.createFile(atPath: "./ffh.ppm", contents: nil)

    let file: FileHandle = try! FileHandle(forWritingTo: URL(fileURLWithPath: "ffh.ppm"))
    defer{
        try! file.close()
    }

    try! file.write(contentsOf: header.data(using: .ascii)!)
    file.write(Data(buffer: img))

    return true
}

func writeToFile(width : Int, height : Int, colorPixel : Vec3<Float>) -> UInt8{
    var header: String = "P3\n\(width) \(height)\n255\n"

    let filePath : URL = URL(fileURLWithPath: "./output.ppm")

    var str = ""
    str.reserveCapacity(width * height * 12)

    let red:   Vec3<Float> = Vec3(x: 255, y: 0, z: 0)
    let yelow: Vec3<Float> = Vec3(x: 255, y: 255, z: 0)

    print(Vec3.lerp(a: red, b: yelow, t: 1))

    

    for j in 0..<height{
        for i in 0..<width{

            let d:  Float = sdfCircle(center: Vec3(x: Float((2 * i - width  )), y: Float((height - 2 * j) ), z: 0), radius: 200)
            let d2: Float = sdfCircle(center: Vec3(x: Float(( 2 * i - width - 400)), y: Float((height - 2 * j) ), z: 0), radius: 150)
            let d3: Float = sdfBox(center: Vec3<Float>(x: Float(2 * i - width - 250), y: Float(height - 2 * j), z: 0), l: Vec3<Float>(x: 250, y: 250, z: 0))

            if d3 < 0 || d2 < 0 || d < 0 {
                str.append(contentsOf: "\(255) \(100) \(220)\n")
            } else{
                // let ir : UInt8 = 255
                // let ig : UInt8 = 255
                // let ib : UInt8 = 255

                // str.append(contentsOf: "\(ir) \(ig) \(ib)\n")
                let colour : Vec3 = Vec3.lerp(a: red, b: yelow, t: clamp(start: 0, end: 1, value: Float(j) / Float(height)))
            

                str.append(contentsOf: "\(UInt8(floor(colour.x))) \(UInt8(floor(colour.y))) \(UInt8(floor(colour.z)))\n")
            }
            
            
        }
    }

    print("Size file image to save: \(MemoryLayout<UInt8>.size * str.count) bytes")
    print(width * height * 12)

    header.append(contentsOf: str)

    try! header.write(to: filePath, atomically: true, encoding: .ascii)
    


    
    return 0
}