using Godot;

namespace EatorbeEaten.Script;

[GlobalClass, Tool]
public partial class Mouse : CharacterBody3D
{
	[Export] public AudioStreamPlayer3D? SqueakSfx;
	public Node3D? Target;

	public override void _PhysicsProcess(double delta)
	{
		if (Target == null)
			return;
		Vector3 path = Target.GlobalPosition - GlobalPosition;
		Velocity = path.Normalized() * 300 * (float)delta;
		MoveAndSlide();
	}
}
