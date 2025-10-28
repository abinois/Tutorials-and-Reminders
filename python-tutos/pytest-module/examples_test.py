import pytest

# --- test prefixed function
def inc(x):
    return x + 1

def test_answer():
    assert inc(3) == 5, 'Checking increase function' # add a message on the assertion


# --- testing errors
def f():
    raise SystemExit(1)

def test_mytest():
    with pytest.raises(SystemExit):
        f()

def test_recursion_depth():
    with pytest.raises(RuntimeError) as excinfo: # get exception
        def f():
            f()
        f()
    assert "maximum recursion" in str(excinfo.value) # access exception infos


# --- test class
class TestClass1:
    def test_one(self):
        x = "this"
        assert "h" in x

    def test_two(self):
        x = "hello"
        assert hasattr(x, "check")


# --- parametrize test functions with decorator
test_list = [("3+5", 8), ("2+4", 6), ("6*9", 42)]

@pytest.mark.parametrize("test_input,expected", test_list)
def test_eval1(test_input, expected):
    assert eval(test_input) == expected


@pytest.mark.parametrize("n,expected", [(1, 2), (3, 4)])
class TestClass2:
    def test_simple_case(self, n, expected):
        assert n + 1 == expected

    def test_weird_simple_case(self, n, expected):
        assert (n * 1) + 1 == expected

# All combinations of multiple parametrized arguments
@pytest.mark.parametrize("x", [0, 1])
@pytest.mark.parametrize("y", [2, 3])
def test_foo(x, y):
    pass

# xpected to fail
@pytest.mark.parametrize(
    "test_input,expected",
    [("3+5", 8), ("2+4", 6), pytest.param("6*9", 42, marks=pytest.mark.xfail)],
)
def test_eval2(test_input, expected):
    assert eval(test_input) == expected