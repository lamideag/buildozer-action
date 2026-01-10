# ==========================
# Dockerfile لبناء تطبيقات Kivy/Buildozer
# ==========================

FROM ubuntu:22.04

# --------------------------
# إعداد المتطلبات الأساسية
# --------------------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    openjdk-11-jdk \
    build-essential \
    git \
    unzip \
    curl \
    wget \
    zip \
    libncurses5-dev \
    libstdc++6 \
    zlib1g-dev \
    libbz2-dev \
    libssl-dev \
    libreadline-dev \
    libsqlite3-dev \
    tk-dev \
    liblzma-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    libgdbm-dev \
    libncursesw5-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------
# إنشاء بيئة افتراضية لتثبيت Buildozer
# --------------------------
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# --------------------------
# تعطيل التحقق من الجذر في Buildozer
# --------------------------
ENV BUILD_ROOT=1

# --------------------------
# تثبيت Buildozer داخل البيئة الافتراضية
# --------------------------
RUN pip install --upgrade pip && \
    pip install buildozer

# --------------------------
# تنزيل Android SDK Command line tools
# --------------------------
RUN mkdir -p /opt/android-sdk/cmdline-tools
WORKDIR /opt/android-sdk/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mv cmdline-tools latest && \
    rm cmdline-tools.zip

# --------------------------
# إعداد متغيرات البيئة
# --------------------------
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# --------------------------
# قبول تراخيص SDK
# --------------------------
RUN yes | sdkmanager --licenses

# --------------------------
# تثبيت أدوات SDK المطلوبة
# --------------------------
RUN sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0" "ndk;25.2.9519653"

# --------------------------
# تحديد مجلد المشروع داخل الحاوية
# --------------------------
WORKDIR /app

# --------------------------
# نسخة اختبارية: Buildozer يعمل الآن داخل الحاوية
# --------------------------
# مثال:
# docker build -t buildozer-android .
# docker run --rm -v /path/to/your/project:/app buildozer-android buildozer android debug
