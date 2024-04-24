import Foundation

//multiply Vec3 by component, operator * is dot product
infix operator .*

//https://www.bit-101.com/2017/2022/01/letting-go-of-random/
// function randn_bm() {
//     var u = 0, v = 0;
//     while(u === 0) u = Math.random(); //Converting [0,1) to (0,1)
//     while(v === 0) v = Math.random();
//     return Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
// }
@inlinable
func randomNumber() -> Float{
    var u: Float = 0
    var v: Float = 0
    while u == 0{
        u = Float.random(in: 0...1)
    }
    while v == 0{
        v = Float.random(in: 0...1)
    }
    return abs(sqrtf(-2 * log(u)) * cos(2 * Float.pi * v)) / 3;
}
@inlinable
func randomNumber(min: Float, max: Float) -> Float{
    return min + (max - min) * randomNumber()
}

@inlinable
func degreesToRadians(degrees: Float) -> Float{
    return degrees * Float.pi / 180
}

@inlinable
func clamp<T: Comparable>(start : T, end: T, value: T) -> T{
    if value < start{
        return start
    } else if value > end{
        return end
    } else {
        return value
    }
}

struct Vec3<Component> where Component: FloatingPoint{
    var x, y, z: Component
   
}

struct Ray<T> where T: FloatingPoint{
    let origin    : Vec3<T>
    var direction : Vec3<T>
}

extension Ray{  
    init(){
        self.origin    = Vec3()
        self.direction = Vec3()
    }

    @inlinable
    func at(t : T) -> Vec3<T> {
        return origin + (t * direction)
    }
}

extension Vec3{

    init(){
        self.x = 0
        self.y = 0
        self.z = 0
    }

    @inlinable
    static func lerp(a : Vec3, b : Vec3, t : Component) -> Vec3{
        return Vec3(x: a.x + t * (b.x - a.x) , y: a.y + t * (b.y - a.y), z: a.z + t * (b.z - a.z))
    }

    @inlinable
    static func absv(a: Vec3) -> Vec3{
        return Vec3(x: abs(a.x), y: abs(a.y), z: abs(a.z))
    }

    @inlinable
    static func maxv(a: Vec3, b: Vec3) -> Vec3{
        return Vec3(x: max(a.x, b.x), y: max(a.y, b.y), z: max(a.z, b.z))
    }

    @inlinable
    static func maxv(a: Vec3, b: Component) -> Vec3{
        return Vec3(x: max(a.x, b), y: max(a.y, b), z: max(a.z, b))
    }

    @inlinable
    func magnitude() -> Component{
        return sqrt(self * self)
    }

    @inlinable
    static func cross(lhs : Vec3, rhs : Vec3) -> Vec3{
        return Vec3(
            x: lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.z * rhs.x - lhs.x * rhs.z,
            z: lhs.x * rhs.y - lhs.y * rhs.x
        )
    }

    @inlinable
    static func + (lhs : Vec3, rhs : Vec3) -> Vec3{
        return Vec3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    @inlinable
    static func - (lhs : Vec3, rhs : Vec3) -> Vec3{
        return Vec3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    @inlinable
    static func .* (lhs : Vec3, rhs : Vec3) -> Vec3{
        return Vec3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }

    @inlinable
    static func * (lhs : Vec3, rhs : Vec3) -> Component {
        let tmp : Vec3 = lhs .* rhs

        return tmp.x + tmp.y + tmp.z
    }

    @inlinable
    static func * (lhs : Component, rhs : Vec3) -> Vec3{
        return Vec3(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }

    @inlinable
    static func += (lhs : inout Vec3, rhs : Vec3){
        lhs = lhs + rhs
    }

    @inlinable
    static func *=(lhs : inout Vec3, rhs: Component){
        lhs.x = lhs.x * rhs
        lhs.y = lhs.y * rhs
        lhs.z = lhs.z * rhs 
    }

    @inlinable
    static func / (lhs: Vec3, rhs : Component) -> Vec3 {
        return Vec3(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    @inlinable
    func normalize() -> Vec3{
        return self / self.magnitude()
    }

    @inlinable
    static prefix func -(vector : Vec3) -> Vec3{
        return Vec3(x: -vector.x, y: -vector.y, z: -vector.z)
    }

    @inlinable
    static func == (lhs : Vec3, rhs : Vec3) -> Bool{
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z 
    }
}

struct Interval<T> where T: FloatingPoint{
    let min: T
    let max: T

    init(){
        self.min = 0
        self.max = T.infinity
    }

    init(min: T, max: T){
        self.min = min
        self.max = max
    }

    func size() -> T{
        return max - min
    }

    func contains(x: T) -> Bool{
        return min <= x && x <= max
    }

    func surround(x: T) -> Bool{
        return min < x && x < max
    }

    
}