# بناء الصورة باستخدام Ubuntu
FROM ubuntu:22.04

# تثبيت الأدوات الأساسية
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

# إنشاء بيئة افتراضية لتثبيت Buildozer
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# تعطيل التحذير حول العمل كـ root
ENV BUILD_ROOT=1

# تثبيت Buildozer
RUN pip install --upgrade pip && \
    pip install buildozer

# تنزيل أدوات Android SDK
RUN mkdir -p /opt/android-sdk/cmdline-tools
WORKDIR /opt/android-sdk/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mv cmdline-tools latest && \
    rm cmdline-tools.zip

# إعداد متغيرات البيئة لـ Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# قبول تراخيص SDK
RUN yes | sdkmanager --licenses

# تثبيت الأدوات المطلوبة
RUN sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0" "ndk;25.2.9519653"

# إنشاء مستخدم غير جذر
RUN useradd -m builduser
USER builduser

# تحديد مجلد العمل للمشروع
WORKDIR /app

# نسخ المشروع إلى الحاوية
COPY . /app

# تنفيذ Buildozer
ENTRYPOINT ["buildozer", "android", "debug"]
