using Godot;

namespace EatorbeEaten.Script;

[GlobalClass, Tool]
public partial class Mouse : CharacterBody3D
{
	[Export] public AudioStreamPlayer3D? SqueakSfx;
	private Sprite3D _sprite;

	public override void _Ready()
	{
		_sprite = GetNode<Sprite3D>("Sprite3D");
	}
	
	public Node3D? Target
	{
		get;
		set;
	}
	
	public override void _Process(double delta)
	{
		_sprite.Visible = Target != null;
	}

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
