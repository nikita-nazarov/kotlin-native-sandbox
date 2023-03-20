
class A(val p: Int) {
    val x = 1
    val y = "AAA"
    val z = 3

    override fun toString(): String {
        return "A STRING"
    }
}

fun main() {
    val a = A(1)
    println()
}
