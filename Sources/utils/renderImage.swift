import Foundation

struct Camera{
    var focalLenght: Float = 1
    var viewporthWidth: Float = 16
    var viewportHeight: Float = 9
    var center: Vec3<Float> = Vec3<Float>(x: 0, y: 0, z: 0)

    func getViewportU() -> Vec3<Float>{
        return Vec3<Float>(x: viewporthWidth, y: 0, z: 0)
    }

    func getViewportV() -> Vec3<Float>{
        return Vec3<Float>(x: 0, y: -viewportHeight, z: 0)
    }

    func getPixelDeltaU(width: Int) -> Vec3<Float>{
        return getViewportU() / Float(width)
    }

    func getPixelDeltaV(height: Int) -> Vec3<Float>{
        return getViewportV() / Float(height)
    }

    func getViewportUpperLeft() -> Vec3<Float>{
        return center - Vec3<Float>(x: 0, y: 0, z: focalLenght) - (getViewportU() / 2) - (getViewportV() / 2)
    }

    func getPixel00Loc(width: Int, height: Int) -> Vec3<Float>{
        return getViewportUpperLeft() + 0.5 * (getPixelDeltaU(width: width) + getPixelDeltaV(height: height))
    }
}

func writeToPPMBinaryMode(width : Int, height : Int, img: UnsafeMutableBufferPointer<Pixel>, filePath : String){
    let header : String = "P6\n\(width) \(height)\n255\n"
    

    let fileManager: FileManager = FileManager()
    
    fileManager.createFile(atPath: filePath, contents: nil)

    let file: FileHandle = try! FileHandle(forWritingTo: URL(fileURLWithPath: filePath))
    defer{
        try! file.close()
    }

    try! file.write(contentsOf: header.data(using: .ascii)!)
    file.write(Data(buffer: img))
}

func writeToPPMASCIIMode(width: Int, height: Int, imgData: String, filePath: String) {
    var header: String = "P3\n\(width) \(height)\n255\n"

    let filePath : URL = URL(fileURLWithPath: filePath)

    
    header.append(contentsOf: imgData)

    try! header.write(to: filePath, atomically: true, encoding: .ascii)
}

func generateExamplePixelData(width: Int, height: Int, filePath: String){
    
    var str = ""
    str.reserveCapacity(width * height * 12)

    let red:   Vec3<Float> = Vec3(x: 255, y: 0, z: 0)
    let yelow: Vec3<Float> = Vec3(x: 255, y: 255, z: 0)

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

    writeToPPMASCIIMode(width: width, height: height, imgData: str, filePath: filePath)

}

func generateExampleBinaryData(width: Int, height: Int, filePath: String){
    let buffer: UnsafeMutablePointer<Pixel>       = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
    let img:    UnsafeMutableBufferPointer<Pixel> = UnsafeMutableBufferPointer<Pixel>(start: buffer, count: width * height)
    defer{
        buffer.deallocate()
    }

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

    writeToPPMBinaryMode(width: width, height: height, img: img, filePath: filePath)
}

