package chap1;

public class SpeakDemo { // �����ŵ�ͬһ��Դ�ļ���,ֻ�������һ��public��,������Դ�ļ�����Ҫһ��,���Ҹ����±�����main����;
	public static void main(String[] args) { // ��������Էŵ�ͬһ��Դ�ļ���, Ҳ���Էŵ���ͬԴ�ļ���,
												// ������һ�����,�����ÿһ���඼������һ���������ֽ����ļ�
		Dog dog;
		dog = new Dog(); // ����Dog����
		Cat cat;
		cat = new Cat(); // ����Cat����

		Duck duck = new Duck(); // ����Duck����
		dog.doSpeak(); // ���С�
		cat.doSpeak(); // è�С�
		duck.doSpeak(); // Ѽ�ӽС�
	}
}

// 