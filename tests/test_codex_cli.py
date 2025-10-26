"""
Tests for the codex CLI tool used in the orchestrator workflow.
"""
import json
import subprocess
import sys
import os
import pytest


def get_codex_path():
    """Get the path to the codex script."""
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(repo_root, "scripts", "codex")


def run_codex_analyze(payload, output_format="json"):
    """Run codex analyze with the given payload."""
    codex_path = get_codex_path()
    
    if isinstance(payload, dict):
        payload = json.dumps(payload)
    
    cmd = [sys.executable, codex_path, "analyze", f"--output-format={output_format}"]
    
    result = subprocess.run(
        cmd,
        input=payload,
        capture_output=True,
        text=True
    )
    
    return result


class TestCodexCLI:
    """Test suite for the codex CLI tool."""
    
    def test_codex_script_exists(self):
        """Test that the codex script exists and is executable."""
        codex_path = get_codex_path()
        assert os.path.exists(codex_path), f"Codex script not found at {codex_path}"
        assert os.access(codex_path, os.X_OK), "Codex script is not executable"
    
    def test_analyze_null_payload(self):
        """Test analyzing a null payload (scheduled run scenario)."""
        result = run_codex_analyze("null")
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "unknown"
        assert output["agents"] == []
        assert "0 agent(s)" in output["message"]
    
    def test_analyze_empty_payload(self):
        """Test analyzing an empty payload."""
        result = run_codex_analyze("")
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "unknown"
        assert output["agents"] == []
    
    def test_analyze_security_alert(self):
        """Test analyzing a security alert event."""
        payload = {
            "event_type": "security_alert",
            "action": "scan"
        }
        
        result = run_codex_analyze(payload)
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "security_alert"
        assert "PR-CYBR-SECURITY-AGENT" in output["agents"]
        assert len(output["agents"]) == 1
    
    def test_analyze_data_sync(self):
        """Test analyzing a data sync event."""
        payload = {
            "event_type": "data_sync",
            "source": "external"
        }
        
        result = run_codex_analyze(payload)
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "data_sync"
        assert "PR-CYBR-DATA-INTEGRATION-AGENT" in output["agents"]
        assert len(output["agents"]) == 1
    
    def test_analyze_maintenance_event(self):
        """Test analyzing a maintenance event (should not dispatch agents)."""
        payload = {
            "event_type": "maintenance",
            "action": "health_check"
        }
        
        result = run_codex_analyze(payload)
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "maintenance"
        assert output["agents"] == []
    
    def test_analyze_health_check_event(self):
        """Test analyzing a health check event (should not dispatch agents)."""
        payload = {
            "event_type": "health_check"
        }
        
        result = run_codex_analyze(payload)
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "health_check"
        assert output["agents"] == []
    
    def test_analyze_unknown_event(self):
        """Test analyzing an unknown event type."""
        payload = {
            "event_type": "some_unknown_type",
            "data": "test"
        }
        
        result = run_codex_analyze(payload)
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "some_unknown_type"
        assert output["agents"] == []
    
    def test_analyze_invalid_json(self):
        """Test analyzing invalid JSON (should handle gracefully)."""
        result = run_codex_analyze("not valid json {")
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        
        output = json.loads(result.stdout)
        assert output["status"] == "success"
        assert output["event_type"] == "unknown"
        assert output["agents"] == []
    
    def test_analyze_text_output_format(self):
        """Test text output format."""
        payload = {
            "event_type": "security_alert"
        }
        
        result = run_codex_analyze(payload, output_format="text")
        
        assert result.returncode == 0, f"Command failed: {result.stderr}"
        assert "Status: success" in result.stdout
        assert "Event Type: security_alert" in result.stdout
        assert "PR-CYBR-SECURITY-AGENT" in result.stdout


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
