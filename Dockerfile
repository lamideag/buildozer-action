# استخدام صورة Ubuntu كقاعدة
FROM ubuntu:22.04

# تثبيت الأدوات الأساسية
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    openjdk-8-jdk \
    build-essential \
    git \
    unzip \
    curl \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# إنشاء بيئة افتراضية لـ Python
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# تحديث pip داخل البيئة الافتراضية وتثبيت Buildozer
RUN pip install --upgrade pip && pip install buildozer

# تثبيت Android SDK cmdline-tools
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d /opt/android-sdk/cmdline-tools && \
    rm /tmp/cmdline-tools.zip

# إعداد متغيرات البيئة للـ Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:$PATH

# قبول تراخيص SDK
RUN yes | sdkmanager --licenses

# تثبيت الأدوات المطلوبة
RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" "ndk;21.3.6528147"

# إعداد مسار المشروع
WORKDIR /app
