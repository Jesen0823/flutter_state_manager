
import 'package:flutter/material.dart';

class WorkerExplanation extends StatelessWidget {
  const WorkerExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GetX Worker 类型说明",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 12),
          _buildWorkerItem(
            "1. debounce",
            "防抖：用户停止输入后触发，用于搜索等场景",
          ),
          _buildWorkerItem(
            "2. ever",
            "监听：每次值变化都触发，用于登录状态管理",
          ),
          _buildWorkerItem(
            "3. everAll",
            "多值监听：多个值中任何一个变化都触发，用于表单验证",
          ),
          _buildWorkerItem(
            "4. throttle",
            "节流：限制触发频率，用于防止登录尝试过多",
          ),
          _buildWorkerItem(
            "5. once",
            "单次：只触发一次，用于首次提示",
          ),
          _buildWorkerItem(
            "6. interval",
            "间隔：定期触发，用于状态检查",
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
