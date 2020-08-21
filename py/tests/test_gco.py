import pytest

from gco_cppyy import GCO


def test_gco_cppyy_widget():
    w = GCO.GcoWidget(-3)
    assert w.get() == -3


@pytest.mark.parametrize("member_t, member_val", [(int, 1), (float, 3.1), (bool, False)])
def test_gco_cppyy_gadget(member_t, member_val):
    g = GCO.GcoGadget[member_t](member_val)
    assert g.get() == pytest.approx(member_val)
