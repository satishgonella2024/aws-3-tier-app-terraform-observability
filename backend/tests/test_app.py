# backend/tests/test_app.py
import pytest
from app import app

@pytest.fixture
def client():
    app.testing = True
    return app.test_client()

def test_hello(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b"Hello" in response.data
