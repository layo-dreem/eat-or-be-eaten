using Godot;

namespace EatorbeEaten.Script;

[GlobalClass, Tool]
public partial class Mouse : CharacterBody3D
{
	[Export] public AudioStreamPlayer3D? SqueakSfx;
	public Node3D? Target;

	public void Die()
	{
		if (Target == null)
			return;
		PackedScene scene = GD.Load<PackedScene>("res://Scene/mouse_corpse.tscn");
		Node3D corpse = scene.Instantiate<Node3D>();
		Vector3 position = GlobalPosition;
		GetTree().CurrentScene.AddChild(corpse);
		corpse.GlobalPosition = position;
		GlobalPosition = Target.GlobalPosition;
		
	}

	public override void _PhysicsProcess(double delta)
	{
		if (Target == null)
			return;
		Vector3 path = Target.GlobalPosition - GlobalPosition;
		Velocity = path.Normalized() * 150 * (float)delta;
		MoveAndSlide();
	}
}
