import Foundation

struct Camera{
    var imageWidth: Int
    var imageHeight: Int
    var focalLenght: Float
    var viewporthWidth: Float
    var viewportHeight: Float
    var center: Vec3<Float>
    var viewportU: Vec3<Float>
    var viewportV: Vec3<Float>
    var pixelDeltaU: Vec3<Float>
    var pixelDeltaV: Vec3<Float>
    var viewportUpperLeft: Vec3<Float>
    var pixel00Loc: Vec3<Float>
    var samplesPerPixel: Float
    let pixelSamplesScale: Float

    init(imageWidth: Int, imageHeight: Int, focalLenght: Float = 1.0, viewporthWidth: Float = 16, viewportHeight: Float = 9, samplesPerPixel: Float = 10){
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.focalLenght = focalLenght
        self.viewporthWidth = viewporthWidth
        self.viewportHeight = viewportHeight
        self.samplesPerPixel = samplesPerPixel
        self.pixelSamplesScale = 1 / samplesPerPixel

        self.center = Vec3<Float>(x: 0, y: 0, z: 0)
        self.viewportU = Vec3<Float>(x: viewporthWidth, y: 0, z: 0)
        self.viewportV = Vec3<Float>(x: 0, y: -viewportHeight, z: 0)

        self.pixelDeltaU = viewportU / Float(imageWidth)
        self.pixelDeltaV = viewportV / Float(imageHeight)

        self.viewportUpperLeft = center - Vec3<Float>(x: 0, y: 0, z: focalLenght) - (viewportU / 2) - (viewportV / 2)
        self.pixel00Loc = viewportUpperLeft + 0.5 * (pixelDeltaU + pixelDeltaV)

    }

    func rayColor(ray: Ray<Float>, world: Hittable) -> Vec3<Float>{
        var rec: HitRecord = HitRecord(p: Vec3(), normal: Vec3(), t: 0, frontFace: false)
        if world.isHit(ray: ray, rayT: Interval<Float>(min: 0, max: Float.infinity), rec: &rec){
            return 0.5 * (rec.normal + Vec3(x: 1, y: 1, z: 1))
        }

        let unitDirection: Vec3<Float> = ray.direction.normalize()
        let a: Float = 0.5 * (unitDirection.y + 1.0)

        return ((1 - a) * Vec3<Float>(x: 1, y: 1, z: 1)) + (a * Vec3<Float>(x: 0.5, y: 0.7, z: 1))
    }

    func render(world: Hittable){
        var imgData: String = ""
        imgData.reserveCapacity(imageHeight * imageWidth * 12)

        for j: Int in 0..<imageHeight{
            for i: Int in 0..<imageWidth{
                var pixelColor: Vec3<Float> = Vec3<Float>()

                for _ in 0..<UInt32(samplesPerPixel){
                    let ray: Ray = getRay(i: Float(i), j: Float(j))
                    pixelColor += rayColor(ray: ray, world: world)
                }
                let r  = clamp(start: 0, end: 255, value: pixelColor.x * pixelSamplesScale * 255.999)
                let g  = clamp(start: 0, end: 255, value: pixelColor.y * pixelSamplesScale * 255.999)
                let b  = clamp(start: 0, end: 255, value: pixelColor.z * pixelSamplesScale * 255.999)
                //print("\(pixelColor.x) \(pixelColor.y) \(pixelColor.z)")

                imgData.append(contentsOf: "\(UInt8(r))) \(UInt8(g)) \(UInt8(b)) \n")
            }
        }

        writeToPPMASCIIMode(width: imageWidth, height: imageHeight, imgData: imgData, filePath: "./rendered.ppm")
    }

    func getRay(i: Float, j: Float) -> Ray<Float>{
        let offset: Vec3<Float> = sampleSquare()

        let pixelSample = pixel00Loc
                          + ((i + offset.x) * pixelDeltaU)
                          + ((j + offset.y) * pixelDeltaV)

        let rayOrigin = center
        let rayDirection = pixelSample - rayOrigin

        return Ray<Float>(origin: rayOrigin, direction: rayDirection)
    }

    func sampleSquare() ->Vec3<Float>{
        return Vec3<Float>(x: Float.random(in: 0..<1) - 0.5, y: Float.random(in: 0..<1) - 0.5, z: 0)
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

