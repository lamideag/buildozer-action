# ==========================
# Dockerfile Kivy -> APK باستخدام صورة Buildozer الرسمية
# ==========================
FROM ghcr.io/kivy/buildozer:latest

# --- تحديث النظام وتثبيت الأدوات الضرورية ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    openjdk-17-jdk \
    wget unzip zip git build-essential libssl-dev libffi-dev \
    python3-dev libncurses5 libncurses5-dev libgl1-mesa-dev xz-utils sudo && \
    rm -rf /var/lib/apt/lists/*

# --- تثبيت Buildozer و Cython (آخر نسخة) ---
RUN pip install --upgrade pip wheel setuptools cython buildozer

# --- تعيين متغيرات البيئة لـ Android SDK و Java ---
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/build-tools/33.0.2
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# --- تثبيت Android SDK Command Line Tools (أحدث نسخة) ---
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    rm cmdline-tools.zip && \
    mv cmdline-tools latest

# --- قبول تراخيص Android SDK تلقائيًا ---
RUN yes | sdkmanager --licenses

# --- تثبيت أدوات SDK المطلوبة للبناء ---
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2" "ndk;25.2.9519653" "cmake;3.22.1"

# --- تهيئة نقطة الدخول (يمكنك استدعاء Buildozer) ---
COPY entrypoint.py /action/entrypoint.py
ENTRYPOINT ["/action/entrypoint.py"]
