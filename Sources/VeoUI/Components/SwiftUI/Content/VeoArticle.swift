//
//  VeoArticle.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 28/12/2024.
//

import SwiftUI

public struct ArticleData {
    let imageURL: String
    let title: String
    let author: String
    let date: Date
    let content: String

    public init(imageURL: String, title: String, author: String, date: Date, content: String) {
        self.imageURL = imageURL
        self.title = title
        self.author = author
        self.date = date
        self.content = content
    }
}

public struct VeoArticle: View {
    let article: ArticleData
    let type: ArticleType
    var onReadMoreTapped: (() -> Void)?

    public enum ArticleType {
        case short
        case full
    }

    public init(article: ArticleData, type: ArticleType, onReadMoreTapped: (() -> Void)? = nil) {
        self.article = article
        self.type = type
        self.onReadMoreTapped = onReadMoreTapped
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VeoImage(
                url: article.imageURL,
                contentMode: .fill,
                cornerRadius: 12,
                maxWidth: .infinity,
                maxHeight: 200)

            VStack(alignment: .leading, spacing: 8) {
                VeoText(
                    article.title,
                    style: .title2,
                    alignment: .center)

                HStack {
                    VeoText("By \(article.author)", style: .caption)
                    Spacer()
                    VeoText(dateFormatter.string(from: article.date), style: .caption)
                }
                .foregroundColor(.gray)
                Spacer()
                if type == .full {
                    VeoText(
                        article.content,
                        style: .body,
                        lineSpacing: 8)
                } else {
                    VeoText(
                        String(article.content.prefix(100)) + "...",
                        style: .body)

                    if let onReadMoreTapped = onReadMoreTapped {
                        VeoButton(
                            title: "Read More",
                            style: .secondary,
                            shape: .rounded,
                            elevation: 0)
                        {
                            onReadMoreTapped()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        secondaryColor: Color(hex: "#3498db"),
        isRTL: true,
        mainFont: "Rubik-Regular")

    let sampleArticle = ArticleData(
        imageURL: "https://picsum.photos/800/400",
        title: "The Future of Artificial Intelligence in Healthcare",
        author: "Dr. Jane Smith",
        date: Date(),
        content: """
            Artificial Intelligence is revolutionizing healthcare in unprecedented ways. From diagnostic assistance to personalized treatment plans, AI is becoming an invaluable tool for healthcare professionals worldwide. Recent studies have shown that AI-powered systems can detect certain conditions with accuracy rates exceeding 90%.

            However, the integration of AI in healthcare also raises important ethical considerations and challenges that need to be addressed. Privacy concerns, data security, and the need for human oversight remain crucial aspects of this technological evolution.

            As we move forward, the key will be finding the right balance between leveraging AI's capabilities while maintaining the human element that is essential to healthcare. This article explores the current state of AI in healthcare, its potential future applications, and the challenges that lie ahead.
            """)

    let arabicArticle = ArticleData(
        imageURL: "https://picsum.photos/800/400",
        title: "مستقبل الذكاء الاصطناعي في الرعاية الصحية",
        author: "د. سارة أحمد",
        date: Date(),
        content: """
            يُحدث الذكاء الاصطناعي ثورة في مجال الرعاية الصحية بطرق غير مسبوقة. من المساعدة في التشخيص إلى خطط العلاج الشخصية، أصبح الذكاء الاصطناعي أداة لا تقدر بثمن للمتخصصين في الرعاية الصحية في جميع أنحاء العالم. وقد أظهرت الدراسات الحديثة أن الأنظمة المدعومة بالذكاء الاصطناعي يمكنها اكتشاف حالات معينة بمعدلات دقة تتجاوز 90٪.

            ومع ذلك، فإن دمج الذكاء الاصطناعي في الرعاية الصحية يثير أيضًا اعتبارات وتحديات أخلاقية مهمة يجب معالجتها. تظل مخاوف الخصوصية وأمن البيانات والحاجة إلى الإشراف البشري جوانب حاسمة في هذا التطور التكنولوجي.

            مع تقدمنا، سيكون المفتاح هو إيجاد التوازن الصحيح بين الاستفادة من قدرات الذكاء الاصطناعي مع الحفاظ على العنصر البشري الضروري للرعاية الصحية. تستكشف هذه المقالة الوضع الحالي للذكاء الاصطناعي في الرعاية الصحية وتطبيقاته المستقبلية المحتملة والتحديات التي تنتظرنا.

            تشير التقديرات إلى أن سوق الذكاء الاصطناعي في الرعاية الصحية سيصل إلى أكثر من 45 مليار دولار بحلول عام 2026. هذا النمو الهائل يعكس الثقة المتزايدة في تقنيات الذكاء الاصطناعي وإمكاناتها في تحسين نتائج المرضى وتقليل التكاليف الطبية.

            في المستقبل القريب، سنشهد المزيد من التطورات في مجالات مثل:
            • التشخيص المبكر للأمراض
            • التنبؤ بالمخاطر الصحية
            • تطوير الأدوية الشخصية
            • أتمتة المهام الإدارية
            • تحسين تجربة المريض

            ومع ذلك، من المهم أن نتذكر أن الذكاء الاصطناعي هو أداة لدعم الممارسين الصحيين وليس استبدالهم. يجب أن يظل التفاعل البشري والحكم السريري في صميم الرعاية الصحية.
            """)

    return ScrollView {
        VStack(spacing: 32) {
            Group {
                VeoText("Short Article View").font(.headline)
                VeoArticle(
                    article: sampleArticle,
                    type: .short)
                {
                    print("Read more tapped")
                }
            }

            Divider()

            Group {
                VeoText("Full Article View").font(.headline)
                VeoArticle(
                    article: sampleArticle,
                    type: .full)
            }

            Divider()

            Group {
                VeoText("Short Arabic Article Example").font(.headline)
                VeoArticle(
                    article: arabicArticle,
                    type: .short)
                {
                    print("Read more tapped")
                }
            }

            Divider()

            Group {
                VeoText("Full Arabic Article Example").font(.headline)
                VeoArticle(
                    article: arabicArticle,
                    type: .full)
                {
                    print("Read more tapped")
                }
            }
        }
        .padding()
    }
}
