class_name StateFactory

enum { RUNNING, KNOCKBACKED, LOAD_AA, SHOOT, DEATH }

var states

func _init():
    states = {
        RUNNING: RunningState,
        KNOCKBACKED: KnockBackState,
        LOAD_AA: LoadingState,
        SHOOT: ShootState,
        DEATH: DeathState
    }

func get_state(state_name):
    if states.has(state_name):
        return states.get(state_name)