# OkHttp3 aur network libraries ke liye rules
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keepattributes *Annotation*
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Retrofit ke liye rules (agar use ho raha hai)
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
