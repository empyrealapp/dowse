import pytest

from dowse.impls.basic.llms import BasicTweetClassifier as classifier
from dowse.interfaces import Tweet


@pytest.mark.asyncio(loop_scope="session")
async def test_classify_question():
    classification = await classifier.classify(
        Tweet(
            id=1890118705016877145,
            content="tell me about bitcoin",
            creator_id=1414021381298089984,
            creator_name="@user",
        )
    )
    assert classification == "question"


@pytest.mark.asyncio(loop_scope="session")
async def test_classify_commands():
    classification = await classifier.classify(
        Tweet(
            id=1890118705016877145,
            content="buy me $10 of AAVE",
            creator_id=1414021381298089984,
            creator_name="@user",
        )
    )
    assert classification == "commands"


@pytest.mark.asyncio(loop_scope="session")
async def test_classify_unknown():
    classification = await classifier.classify(
        Tweet(
            id=1890118705016877145,
            content="banana hotdog dishwasher",
            creator_id=1414021381298089984,
            creator_name="@user",
        )
    )
    assert classification == "not_talking"
