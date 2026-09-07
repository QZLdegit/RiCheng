"""MAGI FastAPI 服务入口（S0 空壳）。

S0 里程碑只交付 /healthz 健康检查；数据库、REST 路由、同步引擎、
AI 代理等随 S1+ 里程碑引入（见 docs/ROADMAP.md）。
"""
from fastapi import FastAPI

app = FastAPI(
    title="MAGI API",
    description="MAGI 个人日程管理系统 · 服务端（S0 空壳）",
    version="0.1.0",
)


@app.get("/healthz")
def healthz() -> dict:
    """健康检查。

    S0 阶段仅验证服务存活；DB 连通性检查随 S4 后端里程碑加入。
    """
    return {"status": "ok", "service": "magi-api", "version": "0.1.0"}
