import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final Alignment? alignment;
  final EdgeInsets? padding;

  const HoverButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 200.0, // Default width, customizable
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero, // Default alignment, customizable
  });

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment!, // Controls button position
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: SizedBox(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isHovered
                ? SizedBox(
                    width: widget.width,
                    child: OutlinedButton(
                      onPressed: widget.onPressed,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: Padding(
                        padding: widget.padding!,
                        child: Text(
                          widget.label,
                          key: const ValueKey('outlined'),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight:
                                FontWeight.bold, // Change font weight to bold
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: widget.width,
                    child: ElevatedButton(
                      onPressed: widget.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 230, 87, 144),
                      ),
                      child: Padding(
                        padding: widget.padding!,
                        child: Text(
                          widget.label,
                          key: const ValueKey('filled'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold, // Change font weight to bold
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
