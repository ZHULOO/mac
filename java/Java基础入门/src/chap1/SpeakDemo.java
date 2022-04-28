package chap1;

public class SpeakDemo { // 多个类放到同一个源文件下,只允许存在一个public类,类名和源文件名称要一致,并且该类下必须有main方法;
	public static void main(String[] args) { // 其它类可以放到同一个源文件下, 也可以放到不同源文件下,
												// 不论哪一种情况,编译后每一个类都会生成一个单独的字节码文件
		Dog dog;
		dog = new Dog(); // 生成Dog对象。
		Cat cat;
		cat = new Cat(); // 生成Cat对象。

		Duck duck = new Duck(); // 生成Duck对象。
		dog.doSpeak(); // 狗叫。
		cat.doSpeak(); // 猫叫。
		duck.doSpeak(); // 鸭子叫。
	}
}

// 