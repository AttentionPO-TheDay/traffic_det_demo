# ================= 构建阶段 =================
# 使用 eclipse-temurin（openjdk 官方镜像已退役下架）
FROM maven:3.8-eclipse-temurin-8 AS build
WORKDIR /build

# 先拷贝各模块 pom，利用依赖缓存加速重复构建
COPY pom.xml .
COPY ruoyi-common/pom.xml ruoyi-common/
COPY ruoyi-framework/pom.xml ruoyi-framework/
COPY ruoyi-system/pom.xml ruoyi-system/
COPY ruoyi-quartz/pom.xml ruoyi-quartz/
COPY ruoyi-generator/pom.xml ruoyi-generator/
COPY ruoyi-admin/pom.xml ruoyi-admin/
COPY ruoyi-xttx/pom.xml ruoyi-xttx/

# 拷贝源码并打包（跳过测试）
COPY . .
RUN mvn -B clean package -DskipTests

# ================= 运行阶段 =================
FROM eclipse-temurin:8-jre
WORKDIR /app

ENV TZ=Asia/Shanghai

COPY --from=build /build/ruoyi-admin/target/ruoyi-admin.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-Duser.timezone=Asia/Shanghai", "-Xms512m", "-Xmx512m", "-jar", "app.jar"]